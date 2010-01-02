require 'spec/spec_helper'
require 'tempfile'

describe Configula::Base do
  before(:each) do
    class MyConfig < Configula::Base
      def initialize
        super
        self.config_store_options = {
          :store => Canfigula::Store::YamlStore,
          :file => "/tmp/configula-yaml-store-spec-#{rand*100}.yml"
        }
        
        self.first_config = "value1"
        self.second_config = "value2"
      end
    end
  end

  it "should store in the yaml file specified in the config" do
    config = MyConfig.prepare
    # yaml_file = config.config_store_options[]
    fail
  end
  
end