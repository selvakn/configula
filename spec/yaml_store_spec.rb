require 'spec/spec_helper'
require 'tempfile'

describe Configula::Base do
  before(:each) do
    class MyConfig < Configula::Base
      self.persistance_options = {:store_name => Canfigula::Store::YamlStore, :file => "/tmp/configula-yaml-store-spec-#{rand*100}.yml"}
      
      def initialize
        super
        self.first_config = "value1"
        self.second_config = "value2"
      end
    end
    
    @file_name = MyConfig.persistance_options[:file]
  end

  it "should store in the yaml file specified in the config" do
    config = MyConfig.prepare
    config.persist

    yaml_file_contents = YAML.load_file(@file_name)
    yaml_file_contents.should == {
      "first_config" => "value1", 
      "second_config" => "value2"
    }
  end

  it "should be able to construct configula object from contents read from yaml file" do
    config = MyConfig.prepare
    config.persist

    config_loaded_from_file = MyConfig.load_from_store(@file_name)
    config_loaded_from_file.should == config
  end

end