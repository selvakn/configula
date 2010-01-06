require File.join(File.dirname( __FILE__ ), 'spec_helper')

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
  
  describe "load_config" do
    it "should try to load the config from store" do
      config_from_file = mock(:config_from_file)
      MyConfigOnAbstractStore.should_receive(:load_from_store).and_return(config_from_file)
      MyConfigOnAbstractStore.load_config.should == config_from_file
    end
    
    it "should load from definition if load from store fails" do
      MyConfigOnAbstractStore.should_receive(:load_from_store).and_raise(Exception.new)
      MyConfigOnAbstractStore.load_config.should == @config
    end
  end
end