require 'spec/spec_helper'

describe Canfigula::Store::YamlStore do
  before(:each) do
    class MyConfig < Configula::Base
      def initialize
        super
        config "config_value"
      end
      
    end
    @config = MyConfig.prepare
  end
  
  it "should raise error on trying to save and retriving" do
    lambda{
      @config.persist
    }.should raise_error(Configula::ConfigError, "No store is cofigured")

    lambda{
      MyConfig.load
    }.should raise_error(Configula::ConfigError, "No store is cofigured")
  end
  
  it "should include AbstractStore by default" do
    MyConfig.ancestors.should be_include(Canfigula::Store::AbstractStore)
  end
  
end