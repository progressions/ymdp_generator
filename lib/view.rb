require 'rubygems'
require 'f'
require 'erb'

# Generates new files for a new view.
#
# See YMDP::Generator::Base for more.
#
module YMDP
  module Generator
    # Pieces of code which will be added to existing files by the Modifications class.
    #
    module Snippets
      # Creates a method which will launch the new view from within any other view.
      #
      def launcher_method(view)
        view = view.downcase
        class_name = view.capitalize
<<-OUTPUT

Launcher.launch#{class_name} = function() {
  Launcher.launchTab("#{view}", "#{class_name}");
};
OUTPUT
      end
    end
    
    module Templates
      # Basic processing of templates (ERB by default).
      #
      class Base
        attr_accessor :view, :template_path, :application_path
        
        # View name should be a single word that's valid as a filename.
        #
        def initialize(view, params={})
          @view = view
          @template_path = params[:template_path]
          @application_path = params[:application_path]
          
          raise ArgumentError.new("template_path is required") unless @template_path
          raise ArgumentError.new("application_path is required") unless @application_path
        end
        
        # Write the template to its destination_path after it has been processed.
        #
        def generate
          write_processed_template
        end
        
        # PROCESSING
        
        # Process this template. By default templates are processed with ERB.
        #
        # Override this in a child to change this behavior.
        #
        # _content_ should be a string, which contains the unprocessed source code
        # of the file.
        #
        def process_template(content)
          ERB.new(content, 0, "%<>").result(binding)
        end
        
        # Return the content of this file after it has been processed.
        #
        # Read the unprocessed content from the source_path and pass it to
        # process_template and return the result.
        #
        def processed_template
          unprocessed_content = ""
          File.open(source_path) do |f|
            unprocessed_content = f.read
          end
          process_template(unprocessed_content)
        end
        
        # FILE I/O
        
        # Write the result of processed_template to the destination path.
        #
        def write_processed_template
          if confirm_overwrite(destination_path)
            append_to_file(destination_path, processed_template)
          end
        end
        
        # Append the content to a file and log that it's happening.
        #
        def append_to_file(file, content)
          File.open(file, "a") do |f|
            $stdout.puts "  #{display_path(file)} writing . . ."
            f.puts content
          end
        end
        
        # PATH HELPERS
        
        # Generate the destination path for this file from its destination directory
        # and its filename.
        #
        def destination_path
          "#{destination_dir}/#{destination_filename}"
        end
        
        # Generate the source path from the template directory and the source filename.
        #
        def source_path
          "#{template_path}/#{source_filename}"
        end
        
        # The source filename for the blank template file.
        #
        def source_filename
          raise "Define in child"
        end
        
        # The destination filename based on the view name of this object.
        #
        def destination_filename
          raise "Define in child"
        end
        
        # The destination directory based on the application_path and type of this object.
        #
        def destination_dir
          raise "Define in child"
        end

        # friendlier display of paths
        def display_path(path)
          path = File.expand_path(path)
          path.gsub(BASE_PATH, "")
        end

        def confirm_overwrite(path)
          if File.exists?(path)
            $stdout.puts "File exists: #{File.expand_path(path)}"
            $stdout.print "  overwrite? (y/n)"
            answer = $stdin.gets
        
            answer =~ /^y/i
          else
            true
          end          
        end
      end
      
      # A View is an HTML file, located at "#{BASE_PATH}/app/views/_view_.html.haml".
      # 
      # The source template for new view files is located at "generator/templates/view.html.haml".
      # 
      # ERB is also supported, but is not recommended.
      #
      class View < Base
        def source_filename
          "view.html.haml"
        end
        
        def destination_filename
          "#{view}.html.haml"
        end
        
        def destination_dir
          "#{application_path}/views"
        end
      end
    
      # JavaScripts are located at "#{BASE_PATH}/app/javascripts/_view_.js".
      #
      # The source templates are found at "generator/templates/javascript.js"
      #
      class JavaScript < Base
        def source_filename
          "javascript.js"  
        end
        
        def destination_filename
          "#{view}.js"
        end
        
        def destination_dir
          "#{application_path}/javascripts"
        end
      end
    
      # Stylesheets are located at "#{BASE_PATH}/app/stylesheets/_view_.css".
      #
      # The source templates are found at "generator/templates/stylesheet.css"
      #
      class Stylesheet < Base
        def source_filename
          "stylesheet.css"
        end
        
        def destination_filename
          "#{view}.css"
        end
        
        def destination_dir
          "#{application_path}/stylesheets"
        end
      end
    
      # Translations are located at "#{BASE_PATH}/app/assets/yrb/en-US/new_view_en-US.pres".
      #
      # The source templates are found at "generator/templates/translation.pres"
      #
      class Translation < Base
        def source_filename
          "translation.pres"
        end
        
        def destination_filename
          "new_#{view}_en-US.pres"
        end
        
        def destination_dir
          "#{application_path}/assets/yrb/en-US"
        end
      end
      
      # Modifications cover anything that needs to be done to existing files when a
      # new view is added.
      #
      class Modifications < Base
        include Snippets
        
        def generate
          content = launcher_method(view)
          append_to_file(destination_path, content)
        end
        
        def destination_filename
          "launcher.js"
        end
        
        def destination_dir
          "#{application_path}/javascripts"
        end
      end
    end
  end
end