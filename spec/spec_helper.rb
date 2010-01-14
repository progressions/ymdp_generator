$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

BASE_PATH = File.dirname(__FILE__)

require 'ymdp_generator'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
