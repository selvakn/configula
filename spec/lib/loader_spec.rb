require File.expand_path(File.dirname(__FILE__) + '/../rails_spec_helper')

describe Configula do
  before(:each) do
    @all_env_yml_file = "#{RAILS_ROOT}/config/configula/environment.yml"
    @test_env_yml_file = "#{RAILS_ROOT}/config/configula/test.yml"

    @all_env_config = YAML.load_file(@all_env_yml_file)
    @test_env_config = YAML.load_file(@test_env_yml_file)

    @app_config = @all_env_config.merge(@test_env_config)
  end

  it "should load config from yaml on default location if block is passsed" do
    config = Configula.prepare
    config.should == @app_config
  end

  describe "with options" do
    describe "with yaml file option" do
      it "should take yaml files option" do
        config = Configula.prepare do |config|
          config.yaml_files = ["environment.yml", "test.yml"]
        end
        config.should == @app_config
      end

      it "should take yml file with the .yml extension" do
        config = Configula.prepare do |config|
          config.yaml_files = ["environment", "test"]
        end
        config.should == @app_config
      end
    end

    it "should take list of hashes option" do
      config = Configula.prepare do |config|
        config.hashes = [@all_env_config, @test_env_config]
      end
      config.should == @app_config
    end

    describe "load from file" do
      before(:each) do
        @store_options = {
          :name => Configula::Store::YamlStore,
          :file => "the/store/file/path"
        }

        YAML.stub!(:load_file).and_return(@app_config)
      end

      it "should try to load the config from store" do
        YAML.should_receive(:load_file).with(@store_options[:file]).and_return(@app_config)

        config = Configula.prepare do |config|
          config.yaml_files = ["environment"]
          config.store = @store_options
        end

        config.should == @app_config
      end
      
      it "should load from definition if load from store fails" do
        config_from_store = Configula::Base.new
        Configula::Base.should_receive(:prepare).with(@app_config).and_return(config_from_store)

        config = Configula.prepare do |config|
          config.yaml_files = ["environment"]
        end
        config.should == config_from_store
      end
      
      it "should set the configula store options" do
        config = Configula.prepare do |config|
          config.yaml_files = ["environment"]
          config.store = @store_options
        end

        config.store.should == @store_options
      end
      
      it "should set store option even on load from store failures" do
        config_from_store = Configula::Base.new
        Configula::Base.should_receive(:prepare).with(@app_config).and_return(config_from_store)

        store_options = @store_options.merge(:file => nil, :name => nil)
        config = Configula.prepare do |config|
          config.yaml_files = ["environment"]
          config.store = store_options
        end

        config.store.should == store_options
      end
    end
  end
end