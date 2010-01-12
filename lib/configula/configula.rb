require File.join(File.dirname( __FILE__ ), 'store/abstract_store')
require File.join(File.dirname( __FILE__ ), 'store/yaml_store')

module Configula
  class Base < Hash
    def self.prepare(*config_hashes)
      basic_hash = config_hashes.delete_at(0)
      raise ConfigError.new("atleast one hash has to be passed") unless basic_hash
      
      config = self.from_hash(basic_hash)
      config_hashes.each do |hash|
        config.partial_set(hash)
      end
      config.prepare!
    end
    
    def reset(hash)
      keys.each{|key| delete(key)}
      hash.each do |key, value|
        set(key, value)
      end
      prepare!
    end

    def prepare!
      each do |key, value|
        case
        when value.kind_of?(String)
          self[key] = eval("%Q{#{value}}")
        when value.kind_of?(Configula::Base)
          value.prepare!
        end
      end
      
      @prepared = true
      self
    end
    
    def self.from_hash(hash)
      new.reset(hash)
    end
    
    def partial_set(hash)
      hash.each do |key, value|
        if value.kind_of?(Hash)
          old_value = get(key)
          set(key, Configula::Base.new) if( !(old_value.kind_of?(Base)) || old_value.nil?)
          get(key).partial_set(value)
        else
          set(key, value)
        end
      end
      self
    end

    private
    def prepared?
      @prepared ||= false
    end

    def set(key, value)
      value_to_set = value.kind_of?(Hash) ? Base.from_hash(value) : value
      self[key.to_s] = value_to_set
    end
    
    def get(key)
      self[key.to_s]
    end

    def method_missing(method_name, *args)
      method_name_string = method_name.to_s
      raise ConfigError.new("trying to change after preparing") if(method_name_string[-1,1] == '=' and !args.empty?)
      get(method_name)
    end

    include Store::AbstractStore
  end
end