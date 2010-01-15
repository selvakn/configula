require File.expand_path(File.dirname(__FILE__) + '/../rails_spec_helper')
# require File.join(File.dirname( __FILE__ ), '..', 'spec_helper')

describe Configula do
  before(:each) do
    @all_env_yml_file = "#{RAILS_ROOT}/config/configula/environment.yml"
    @test_env_yml_file = "#{RAILS_ROOT}/config/configula/test.yml"
    
    @all_env_config = YAML.load_file(@all_env_yml_file)
    @test_env_config = YAML.load_file(@test_env_yml_file)
  end
  
  it "should load config from yaml on default location if block is passsed" do
    config = Configula.prepare
    assert_config_as_yaml(config)
  end
  
  describe "with options" do
    describe "with yaml file option" do
      it "should take yaml files option" do
        config = Configula.prepare do |config|
          config.yaml_files = ["environment.yml", "test.yml"]
        end
        assert_config_as_yaml(config)
      end
      
      it "should take yml file with the .yml extension" do
        config = Configula.prepare do |config|
          config.yaml_files = ["environment", "test"]
        end
        assert_config_as_yaml(config)
      end
    end

    it "should take list of hashes option" do
      config = Configula.prepare do |config|
        config.hashes = [@all_env_config, @test_env_config]
      end
      assert_config_as_yaml config
    end
    
    it "should try to load the config from store"
    
    it "should load from definition if load from store fails"
    
    it "should set the configula store options" do
      config  = Configula.prepare do |config|
        config.yaml_files = ["environment"]
        config.store = {
          :name => Configula::Store::YamlStore
        }
      end
      
      config.store.should == {:name => Configula::Store::YamlStore}
    end
    
  end
  
  def assert_config_as_yaml(config)
    config.should == @all_env_config.merge(@test_env_config)
  end
end