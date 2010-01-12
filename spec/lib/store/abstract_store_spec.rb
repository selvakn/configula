require File.join(File.dirname( __FILE__ ), '..', '..', 'spec_helper')

describe Configula::Store::AbstractStore do
  before(:each) do
    @hash = {
        :config => "config_value"
    }
    @config = Configula.prepare do |config|
      config.hashes = [@hash]
    end
      
  end
  
  it "should raise error on trying to save and retriving" do
    lambda{
      @config.persist
    }.should raise_error(Configula::ConfigError, "No store is cofigured")

    lambda{
      @config.load_from_store
    }.should raise_error(Configula::ConfigError, "No store is cofigured")
  end
  
  it "should include AbstractStore by default" do
    Configula::Base.ancestors.should be_include(Configula::Store::AbstractStore)
  end
  
  describe "load_config" do
    it "should try to load the config from store" do
      pending "move to loader spec"
      config_from_file = mock(:config_from_file)
      Configula::Base.should_receive(:load_from_store).and_return(config_from_file)
      Configula::Base.load_config.should == config_from_file
    end
    
    it "should load from definition if load from store fails" do
      pending "move to loader spec"
      Configula::Base.should_receive(:load_from_store).and_raise(Exception.new)
      Configula::Base.load_config.should == @config
    end
  end
end