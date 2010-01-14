require 'view'

# Generates a new view, with all the associated files relating to that view.
#
# Creates the following files:
#
# 1. View, at "#{BASE_PATH}/app/assets/views/_view_.html.haml"
# 
#    A Haml file with a single line of boilerplate copy.
#
# 2. JavaScript file, at "#{BASE_PATH}/app/javascripts/_view_.js"
#    
#    A complete set of the basic JavaScript functions needed to execute a page.
#
# 3. Stylesheet, at "#{BASE_PATH}/app/stylesheets/_view_.css"
# 
#    A blank CSS file.
#
# 4. Translation keys, at "#{BASE_PATH}/app/assets/yrb/en-US/new_view_en-US.pres"
#
#    A new translation file, with a heading and a subhead key.
#
# 5. Modification
#
#    Currently the only modification to any existing files is the creation of a 'launcher' method
#    in "#{BASE_PATH}/app/javascripts/launcher.js"
#
# 6. Translation of new keys into all languages.
#
#    Translates the new keys into all languages and creates associated ".pres" files in the
#    correct subdirectories.
#
module YMDP
  module Generator
    # Parses the command as the first parameter and generates the appropriate files.
    #
    class Base
      attr_accessor :template_path, :application_path
      
      def initialize(params={})
        @template_path = params[:template_path]
        @application_path = params[:application_path]
      end
      
      def generate(view)
        $stdout.puts "Create a new view: #{view}"
        
        p = {
          :template_path => template_path,
          :application_path => application_path
        }
      
        YMDP::Generator::Templates::View.new(view, p).generate
        YMDP::Generator::Templates::JavaScript.new(view, p).generate
        YMDP::Generator::Templates::Stylesheet.new(view, p).generate
        YMDP::Generator::Templates::Translation.new(view, p).generate
        YMDP::Generator::Templates::Modifications.new(view, p).generate
      end
    end
  end
end
