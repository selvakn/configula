require File.join(File.dirname( __FILE__ ), '..', 'spec_helper')

describe Configula::Base do
  before(:each) do
    @hash = {
      :string_config => "some_string_value",
      :ar_style_interpol_config => "this is a {{string_config}}",
      :another_config => "another_config",
      :chaining => {
        "config" => "chaining config",
        "config2" => "chaining config2"
      },
      :array_config => [1, 2, "three"],
      :hash_config => {
        :key1 => :value1, 
        :key2 => ["values", nil, 1, :whatever]
      },
    }
  end
  
  describe "setting of basic values" do
    before(:each) do
      @config = Configula::Base.prepare(@hash)
    end
    
    it "for basic string" do
      @config.string_config.should == "some_string_value"
    end
    
    it "should eval config when it is a string with interpolation" do
      @config.ar_style_interpol_config.should == "this is a some_string_value"
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

    it "should not allow changes with method=" do
      lambda {
        @config.string_config = "new value"
      }.should raise_error(Configula::ConfigError, "trying to change after preparing")

      lambda {
        @config.new_config = "someother new value"
      }.should raise_error(Configula::ConfigError, "trying to change after preparing")
    end

    describe "with set" do
      it "should allow changes with set method" do
        @config.send(:set, :new_config, "someother new value")
        @config.new_config.should == "someother new value"

        @config.send(:set, :new_config, "someother new new value")
        @config.new_config.should == "someother new new value"
      end

      it "should convert a hash into configula object when assigned with set" do
        @config.send(:set, :new_hash_sith_set, {"a" => "b", "c" => "d"})
        @config.new_hash_sith_set.a.should == "b"
        @config.new_hash_sith_set.c.should == "d"
      end

      describe "reset from hash" do
        it "should reset keys not passed as nil" do
          lambda{
            @config.reset(:hash_config => {"a" => "b"}, :new_string => "new string")
          }.should change{@config.keys.size}.by(-4)
          
          @config.keys.size.should == 2
          @config.hash_config.should == {"a" => "b"}
          @config.new_string.should == "new string"
        end
        
        it "should prepare the values before setting" do
          @config.reset(:hash_config => {"a" => "b"}, :new_string => '{{hash_config["a"]}}')
          @config.hash_config.should == {"a" => "b"}
          @config.new_string.should == "b"
        end
      end

      describe "partial set" do
        it "should do a patial update (i.e) only for the tail values" do
          @config.reset :new_hash_sith_set => {"a" => "b", "c" => "d"}
          @config.new_hash_sith_set.a.should == "b"
          @config.new_hash_sith_set.c.should == "d"

          @config.send :partial_set, :new_hash_sith_set => {"a" => "new_a"}
          @config.new_hash_sith_set.a.should == "new_a"
          @config.new_hash_sith_set.c.should == "d"
        end
        
        it "should be able to do a partial set of a key whose previous value was a string/array/integer but now a hash" do
          @config.reset :old_config1 => "string", :old_config2 => 1, :old_config3 => [1, "string"]
          @config.old_config1.should == "string"
          @config.old_config2.should == 1
          @config.old_config3.should == [1, "string"]

          @config.send :partial_set, :old_config1 => {"a" => "new_a"}, :old_config2 => {"b" => "new_b"}, :old_config3 => {"c" => "new_c"}
          @config.old_config1.a.should == "new_a"
          @config.old_config2.b.should == "new_b"
          @config.old_config3.c.should == "new_c"
        end
      end
    end

    it "should convert the config into hash" do
      @config.should == {
        "another_config" => "another_config",
        "array_config" => [1, 2, "three"],
        "chaining" => { 
          "config" => "chaining config", 
          "config2" => "chaining config2"
        },
        "hash_config" => {
          "key1" => :value1,
          "key2" => ["values", nil, 1, :whatever]
        },
        "ar_style_interpol_config" => "this is a some_string_value",
        "string_config" => "some_string_value"
      }
    end
    
    it "should raise error if no hash is passed for preparing" do
      lambda{
        Configula::Base.prepare()
      }.should raise_error(Configula::ConfigError, "atleast one hash has to be passed")
    end
  end

  it "should allow overriding of the values with multiple hash" do
    overriding_hash = {
      :string_config => "new string value",
      :chaining => {
        :config => "new config chaining"
      }
    }
    
    config = Configula::Base.prepare(@hash, overriding_hash)

    config.string_config.should == "new string value"
    config.chaining.config.should == "new config chaining"
  end
  
end