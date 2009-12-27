require File.join(File.dirname( __FILE__ ), 'spec_helper')

describe Configula do
  before(:each) do
    class MyConfig < Configula
      def initialize
        super
        set :string_config, "some_string_value"
        set :proc_config, lambda{ "this is a proc: #{string_config}" }

        another_config "another_config"
        self.config_equals = "config_equals"
        chaining.config = "chaining config"
        chaining.config2 = "chaining config2"
      end
    end
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
      @config.chaining.config2.should == "chaining config2"
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

end

describe Configula, "should inspect properlly for" do
  it "empty config" do
    class MyConfig < Configula
      def initialize
        super
      end
    end
    MyConfig.prepare.inspect.should == "{}"
  end

  it "with one level of values" do
    class MyConfig < Configula
      def initialize
        super
        asd "value1"
        qwe "value2"
      end
    end
    MyConfig.prepare.inspect.should == 
'{
"asd" => "value1",
"qwe" => "value2"
}'
  end

  it "two levels" do
    class MyConfig < Configula
      def initialize
        super
        asd "value1"
        qwe "value2"
        zxc.cvb "value3"
        zxc.vbn "value4"
      end
    end
    MyConfig.prepare.inspect.should == 
'{
"asd" => "value1",
"qwe" => "value2",
"zxc" => {
"cvb" => "value3",
"vbn" => "value4"
}
}'
  end
end