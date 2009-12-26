require File.join(File.dirname( __FILE__ ), 'spec_helper')

describe Configula do
  before(:each) do
    class MyConfig < Configula
      def initialize
        set :string_config, "some_string_value"
        set :proc_config, lambda{ "this is a proc: #{string_config}" }
        
        another_config "another_config"
        self.config_equals = "config_equals"
        chaining.config = "chaining config"
      end
    end
  end

  after(:each) do
    MyConfig.reset
  end

  describe "setting of basic values" do
    before(:each) do
      @config = MyConfig.prepare
    end

    it "should call the proc config when it is a proc " do
      @config.proc_config.should == "this is a proc: some_string_value"
    end

    it "should allow values assigned with set setting of values with set" do
      @config.string_config.should == "some_string_value"
    end

    it "should allow setting of values by calling the config as a method" do
      @config.another_config.should == "another_config"
    end

    it "should allow setting of values by calling the config as a method=" do
      @config.config_equals.should == "config_equals"
    end

    it "should multi step chaining config" do
      @config.chaining.config.should == "chaining config"
    end

    it "should return nil value for unknown config" do
      @config.some_unknown_key.should == nil
    end
  end

  it "should allow overriding of the values with inherting" do
    class InheritedConfig < MyConfig
      def initialize
        super
        set :string_config, "new string value"
        self.config_equals = "new config equals"
        chaining.config = "new config chaining"
      end
    end

    config = InheritedConfig.prepare

    config.string_config.should == "new string value"
    config.config_equals.should == "new config equals"
    config.chaining.config.should == "new config chaining"
  end

  it "should not allow changes after preparing" do
    MyConfig.prepare

    class InheritedConfig < MyConfig
      def initialize
        super
        set :string_config, "new string value"
        self.config_equals = "new config equals"
        chaining.config = "new config chaining"
      end
    end

    lambda { InheritedConfig.prepare }.should raise_error
  end
end