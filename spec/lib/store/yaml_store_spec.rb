require File.join(File.dirname( __FILE__ ), '..', '..', 'spec_helper')
require 'tempfile'

describe Configula::Store::YamlStore do
  before(:each) do
    @hash = {
      :first_config => "value1",
      :second_config => "value2"
    }
    
    @store_options = {
      :name => Configula::Store::YamlStore,
      :file => "/tmp/configula-yaml-store-spec-#{rand*100}.yml"
    }
  end
  
  describe "storing and retriving" do
    before(:each) do
      @config = Configula::Base.new
      @config.store = @store_options
      @config.reset(@hash)
    end
    
    it "should store in the yaml file specified in the config" do
      @config.persist

      yaml_file_contents = YAML.load_file(@store_options[:file])
      yaml_file_contents.should == {
        "first_config" => "value1", 
        "second_config" => "value2"
      }
    end

    it "should be able to construct configula object from contents read from yaml file" do
      @config.persist

      new_config = Configula::Base.new
      new_config.store = @store_options
      
      new_config.load_from_store
      new_config.should == @config
    end
  end
  
  it "should raise load error if not able to find the file" do
    YAML.should_receive(:load_file).with(@store_options[:file]).and_raise(Errno::ENOENT.new("not found"))
    
    config = Configula::Base.new
    config.store = @store_options
    
    lambda{
      config.load_from_store
    }.should raise_error(Configula::Store::LoadFromStoreError)
  end
  
  it "should raise load error for all yaml load failures"
end