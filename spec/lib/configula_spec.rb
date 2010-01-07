require File.join(File.dirname( __FILE__ ), '..', 'spec_helper')

describe Configula::Base do
  before(:each) do
    class MyConfig < Configula::Base
      def initialize
        set :string_config, "some_string_value"
        set :proc_config, defer{ "this is a proc: #{string_config}" }
        set :proc_config_without_block, 'this is a proc: #{string_config}'

        another_config "another_config"
        self.config_equals = "config_equals"
        chaining.config = "chaining config"
        chaining.config2 = "chaining config2"
        array_config [1, 2, "three"]
        hash_config({:key1 => :value1, :key2 => ["values", nil, 1, :whatever]})
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

    it "should eval config when it is not a proc but a string with interpolation" do
      @config.proc_config_without_block.should == "this is a proc: some_string_value"
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
    
    it "should allow accessing the config chainied as a hash" do
      @config.chaining.should == {
        "config" => "chaining config",
        "config2" => "chaining config2"
      }
    end

    it "should return nil value for unknown config" do
      @config.some_unknown_key.should == nil
    end
    
    describe "should allow storing of other valid JSON types" do
      it "array" do
        @config.array_config.should == [1, 2, "three"]
      end
      
      it "hash" do
        @config.hash_config.should == {
          "key1" => :value1,
          "key2" => ["values", nil, 1, :whatever]
        }
      end
      
      it "should convert the hash into another configula object" do
        @config.hash_config.key1.should == :value1
        @config.hash_config.key2.should == ["values", nil, 1, :whatever]
      end
    end
  end

  it "should allow overriding of the values with inherting" do
    class InheritedConfig < MyConfig
      def initialize
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
    config = MyConfig.prepare
    lambda {
      config.string_config = "new value"
    }.should raise_error(Configula::ConfigError, "trying to change after preparing")

    lambda {
      config.new_config = "someother new value"
    }.should raise_error(Configula::ConfigError, "trying to change after preparing")
  end
  
  it "should allow changes with set method" do
    config = MyConfig.prepare
    config.set(:new_config, "someother new value")
    config.new_config.should == "someother new value"

    config.set(:new_config, "someother new new value")
    config.new_config.should == "someother new new value"
  end
  
  it "convert the config into hash" do
    config = MyConfig.prepare
    config.should == {
      "another_config" => "another_config",
      "array_config" => [1, 2, "three"],
      "config_equals" => "config_equals", 
      "chaining" => { 
        "config" => "chaining config", 
        "config2" => "chaining config2"
      },
      "hash_config" => {
        "key1" => :value1,
        "key2" => ["values", nil, 1, :whatever]
      },
      "proc_config" => "this is a proc: some_string_value", 
      "proc_config_without_block" => "this is a proc: some_string_value",
      "string_config" => "some_string_value"
    }
  end
end