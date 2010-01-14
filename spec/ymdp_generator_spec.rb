require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Generate" do
  before(:each) do
    # stub screen I/O
    $stdout.stub!(:puts)
    $stdout.stub!(:print)
    
    @template_path = "templates"
    @application_path = "app"
    @p = {
      :template_path => @template_path,
      :application_path => @application_path
    }
  end
  
  describe "Base" do
    before(:each) do
      @generator = mock('generator', :generate => true)
      YMDP::Generator::Templates::View.stub!(:new).and_return(@generator)
      YMDP::Generator::Templates::JavaScript.stub!(:new).and_return(@generator)
      YMDP::Generator::Templates::Stylesheet.stub!(:new).and_return(@generator)
      YMDP::Generator::Templates::Translation.stub!(:new).and_return(@generator)
      YMDP::Generator::Templates::Modifications.stub!(:new).and_return(@generator)
    end
    
    describe "new view" do
      before(:each) do
        @base = YMDP::Generator::Base.new(@p)
      end
      
      describe "instantiation" do
        it "should create a new instance" do
          @base.should_not be_nil
        end
        
        it "should set template_path" do
          @base.template_path.should == @template_path
        end
      end
      
      it "should generate a new view" do
        YMDP::Generator::Templates::View.should_receive(:new).with("funk", @p)
        @base.generate("funk")
      end
      
      it "should generate a new JavaScript" do
        YMDP::Generator::Templates::JavaScript.should_receive(:new).with("funk", @p)
        @base.generate("funk")
      end
      
      it "should generate a new stylesheet" do
        YMDP::Generator::Templates::Stylesheet.should_receive(:new).with("funk", @p)
        @base.generate("funk")
      end
      
      it "should generate a new translation" do
        YMDP::Generator::Templates::Translation.should_receive(:new).with("funk", @p)
        @base.generate("funk")
      end
      
      it "should generate a new set of modifications" do
        YMDP::Generator::Templates::Modifications.should_receive(:new).with("funk", @p)
        @base.generate("funk")
      end
    end
  end
  
  def stub_file_io(unprocessed_file)
    # stub file I/O
    @file ||= mock('file').as_null_object
    @file.stub!(:read).and_return(unprocessed_file)
      
    File.stub!(:exists?).and_return(false)
    File.stub!(:open).and_yield(@file) 
  end
  
  def stub_erb(processed_file)
    # stub ERB
    @erb ||= mock('erb').as_null_object
    @erb.stub!(:result).and_return(processed_file)
    ERB.stub!(:new).and_return(@erb)
  end
  
  describe "subclasses" do
    before(:each) do
      @view = "funk"
    end
    
    describe "View" do
      before(:each) do
        @view_regex = /app\/views\/#{@view}\.html\.haml/
      
        # before and after
        @unprocessed_file = "This is the <%= @view %> view."
        @processed_file = "This is the #{@view} view."
        
        @source_filename = "#{@template_path}/view.html.haml"
      
        stub_file_io(@unprocessed_file)
        stub_erb(@processed_file)
        
        @generator = YMDP::Generator::Templates::View.new(@view, @p)
      end

      describe "instantiation" do    
        it "should make a new instance" do
          @generator.should_not be_nil
        end
    
        it "should set view" do
          @generator.view.should == @view
        end
      
        it "should set template_path" do
          @generator.template_path.should == @template_path
        end
        
        it "should raise error without template_path" do
          lambda {
            YMDP::Generator::Templates::View.new(@view, :destination_dir => "destination")
          }.should raise_error(ArgumentError)
        end
        
        it "should raise error without destination_dir" do
          lambda {
            YMDP::Generator::Templates::View.new(@view, :template_path => "templates")
          }.should raise_error(ArgumentError)
        end
      end
    
      describe "generation" do
        it "should read the source file" do
          File.should_receive(:open).with(@source_filename)
          @generator.generate
        end
      
        describe "file exists" do
          before(:each) do
            $stdin.stub!(:gets).and_return("y")
            File.stub!(:exists?).with(@view_regex).and_return(true)
          end
      
          it "should confirm the file exists" do
            File.should_receive(:exists?).with(@view_regex).and_return(false)
            @generator.generate
          end
        
          it "should prompt to overwrite if the file exists" do
            $stdout.should_receive(:print).with(/overwrite\?/)
            @generator.generate
          end
        
          it "should overwrite if the answer is no" do
            File.should_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        
          it "should not overwrite if the answer is no" do
            $stdin.stub!(:gets).and_return("n")
            File.should_not_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        end
      
        describe "processing" do
          it "should instantiate ERB" do
            ERB.should_receive(:new).with(@unprocessed_file, anything, anything).and_return(@erb)
            @generator.generate
          end
        
          it "should get result from ERB" do
            @erb.should_receive(:result)
            @generator.generate
          end
        
          it "should write the processed result" do
            @file.should_receive(:puts).with(@processed_file)
            @generator.generate
          end
        end
      
        it "should write the file" do
          File.should_receive(:open).with(@view_regex, "a")
          @generator.generate
        end
      end
    end
    
    describe "JavaScript" do
      before(:each) do
        @view_regex = /app\/javascripts\/#{@view}\.js/
        
        # before and after
        @unprocessed_file = "This is the <%= @view %> JavaScript."
        @processed_file = "This is the #{@view} JavaScript."
        
        @source_filename = "#{@template_path}/javascript.js"
      
        stub_file_io(@unprocessed_file)
        stub_erb(@processed_file)
        
        @generator = YMDP::Generator::Templates::JavaScript.new(@view, @p)
      end

      describe "instantiation" do    
        it "should make a new instance" do
          @generator.should_not be_nil
        end
    
        it "should set view" do
          @generator.view.should == @view
        end
      
        it "should set template_path" do
          @generator.template_path.should == @template_path
        end
      end
    
      describe "generation" do
        it "should read the source file" do
          File.should_receive(:open).with(@source_filename)
          @generator.generate
        end
      
        describe "file exists" do
          before(:each) do
            $stdin.stub!(:gets).and_return("y")
            File.stub!(:exists?).with(@view_regex).and_return(true)
          end
      
          it "should confirm the file exists" do
            File.should_receive(:exists?).with(@view_regex).and_return(false)
            @generator.generate
          end
        
          it "should prompt to overwrite if the file exists" do
            $stdout.should_receive(:print).with(/overwrite\?/)
            @generator.generate
          end
        
          it "should overwrite if the answer is no" do
            File.should_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        
          it "should not overwrite if the answer is no" do
            $stdin.stub!(:gets).and_return("n")
            File.should_not_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        end
      
        describe "processing" do
          it "should instantiate ERB" do
            ERB.should_receive(:new).with(@unprocessed_file, anything, anything).and_return(@erb)
            @generator.generate
          end
        
          it "should get result from ERB" do
            @erb.should_receive(:result)
            @generator.generate
          end
        
          it "should write the processed result" do
            @file.should_receive(:puts).with(@processed_file)
            @generator.generate
          end
        end
      
        it "should write the file" do
          File.should_receive(:open).with(@view_regex, "a")
          @generator.generate
        end
      end
    end
    
    describe "Stylesheet" do
      before(:each) do
        @view_regex = /app\/stylesheets\/#{@view}\.css/
        
        # before and after
        @unprocessed_file = "This is the <%= @view %> stylesheet."
        @processed_file = "This is the #{@view} stylesheet."
        
        @source_filename = "#{@template_path}/stylesheet.css"
      
        stub_file_io(@unprocessed_file)
        stub_erb(@processed_file)
        
        @generator = YMDP::Generator::Templates::Stylesheet.new(@view, @p)
      end

      describe "instantiation" do    
        it "should make a new instance" do
          @generator.should_not be_nil
        end
    
        it "should set view" do
          @generator.view.should == @view
        end
      
        it "should set template_path" do
          @generator.template_path.should == @template_path
        end
      end
    
      describe "generation" do
        it "should read the source file" do
          File.should_receive(:open).with(@source_filename)
          @generator.generate
        end
      
        describe "file exists" do
          before(:each) do
            $stdin.stub!(:gets).and_return("y")
            File.stub!(:exists?).with(@view_regex).and_return(true)
          end
      
          it "should confirm the file exists" do
            File.should_receive(:exists?).with(@view_regex).and_return(false)
            @generator.generate
          end
        
          it "should prompt to overwrite if the file exists" do
            $stdout.should_receive(:print).with(/overwrite\?/)
            @generator.generate
          end
        
          it "should overwrite if the answer is no" do
            File.should_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        
          it "should not overwrite if the answer is no" do
            $stdin.stub!(:gets).and_return("n")
            File.should_not_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        end
      
        describe "processing" do
          it "should instantiate ERB" do
            ERB.should_receive(:new).with(@unprocessed_file, anything, anything).and_return(@erb)
            @generator.generate
          end
        
          it "should get result from ERB" do
            @erb.should_receive(:result)
            @generator.generate
          end
        
          it "should write the processed result" do
            @file.should_receive(:puts).with(@processed_file)
            @generator.generate
          end
        end
      
        it "should write the file" do
          File.should_receive(:open).with(@view_regex, "a")
          @generator.generate
        end
      end
    end
    
    describe "Translation" do
      before(:each) do
        @view_regex = /app\/assets\/yrb\/en-US\/new_#{@view}_en-US\.pres/
        
        # before and after
        @unprocessed_file = "This is the <%= @view %> translation."
        @processed_file = "This is the #{@view} translation."
        
        @source_filename = "#{@template_path}/translation.pres"
      
        stub_file_io(@unprocessed_file)
        stub_erb(@processed_file)
        
        @generator = YMDP::Generator::Templates::Translation.new(@view, @p)
      end

      describe "instantiation" do    
        it "should make a new instance" do
          @generator.should_not be_nil
        end
    
        it "should set view" do
          @generator.view.should == @view
        end
      
        it "should set template_path" do
          @generator.template_path.should == @template_path
        end
      end
    
      describe "generation" do
        it "should read the source file" do
          File.should_receive(:open).with(@source_filename)
          @generator.generate
        end
      
        describe "file exists" do
          before(:each) do
            $stdin.stub!(:gets).and_return("y")
            File.stub!(:exists?).with(@view_regex).and_return(true)
          end
      
          it "should confirm the file exists" do
            File.should_receive(:exists?).with(@view_regex).and_return(false)
            @generator.generate
          end
        
          it "should prompt to overwrite if the file exists" do
            $stdout.should_receive(:print).with(/overwrite\?/)
            @generator.generate
          end
        
          it "should overwrite if the answer is no" do
            File.should_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        
          it "should not overwrite if the answer is no" do
            $stdin.stub!(:gets).and_return("n")
            File.should_not_receive(:open).with(@view_regex, "a")
            @generator.generate
          end
        end
      
        describe "processing" do
          it "should instantiate ERB" do
            ERB.should_receive(:new).with(@unprocessed_file, anything, anything).and_return(@erb)
            @generator.generate
          end
        
          it "should get result from ERB" do
            @erb.should_receive(:result)
            @generator.generate
          end
        
          it "should write the processed result" do
            @file.should_receive(:puts).with(@processed_file)
            @generator.generate
          end
        end
      
        it "should write the file" do
          File.should_receive(:open).with(@view_regex, "a")
          @generator.generate
        end
      end
    end
    
    describe "Modifications" do
      before(:each) do
        @view_regex = /app\/javascripts\/#{@view}\.js/
        
        # before and after
        @unprocessed_file = "This is the <%= @view %> JavaScript."
        @processed_file = "Launcher.launch#{@view.capitalize}"
        
        @source_filename = "app/javascripts/launcher.js"
      
        stub_file_io(@unprocessed_file)
        stub_erb(@processed_file)
        
        @generator = YMDP::Generator::Templates::Modifications.new(@view, @p)
      end

      describe "instantiation" do    
        it "should make a new instance" do
          @generator.should_not be_nil
        end
    
        it "should set view" do
          @generator.view.should == @view
        end
      
        it "should set template_path" do
          @generator.template_path.should == @template_path
        end
      end
    
      describe "generation" do
        it "should read the source file" do
          File.should_receive(:open).with(/#{@source_filename}$/, "a")
          @generator.generate
        end
      
        describe "processing" do
          it "should write the processed result" do
            @file.should_receive(:puts).with(/#{@processed_file}/)
            @generator.generate
          end
        end
      end
    end
  end
end