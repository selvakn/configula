require File.join(File.dirname( __FILE__ ), '..', '..', 'spec_helper')
require 'tempfile'

describe Configula::Store::YamlStore do
  before(:each) do
    hash = {
      :first_config => "value1",
      :second_config => "value2"
    }
    
    @store_options = {
      :name => Configula::Store::YamlStore,
      :file => "/tmp/configula-yaml-store-spec-#{rand*100}.yml"
    }
    
    @config = Configula.prepare do |config|
      config.store = @store_options
      config.hashes = [hash]
    end
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
    new_config.extend Configula::Store::YamlStore
    new_config.store = @store_options
    config_loaded_from_file = new_config.load_from_store
    config_loaded_from_file.should == @config
  end
end