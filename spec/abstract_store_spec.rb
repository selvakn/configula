require 'spec/spec_helper'

describe Canfigula::Store::YamlStore do
  before(:each) do
    class MyConfigOnAbstractStore < Configula::Base
      def initialize
        super
        config "config_value"
      end
      
    end
    @config = MyConfigOnAbstractStore.prepare
  end
  
  it "should raise error on trying to save and retriving" do
    lambda{
      @config.persist
    }.should raise_error(Configula::ConfigError, "No store is cofigured")

    lambda{
      MyConfigOnAbstractStore.load_from_store
    }.should raise_error(Configula::ConfigError, "No store is cofigured")
  end
  
  it "should include AbstractStore by default" do
    MyConfigOnAbstractStore.ancestors.should be_include(Canfigula::Store::AbstractStore)
  end
  
end