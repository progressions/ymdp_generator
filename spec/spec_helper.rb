$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

BASE_PATH = File.dirname(__FILE__)

require 'ymdp_generator'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end



def stub_screen_io
  # stub screen I/O
  $stdout.stub!(:puts)
  $stdout.stub!(:print)    
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