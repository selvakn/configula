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
end