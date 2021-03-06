require File.join(File.dirname( __FILE__ ), 'store/abstract_store')
require File.join(File.dirname( __FILE__ ), 'store/yaml_store')

module Configula
  class Base < Hash
    def self.prepare(*config_hashes)
      new(config_hashes)
    end
    
    def self.empty_config
      prepare({})
    end
    
    def initialize(config_hashes)
      raise ConfigError.new("atleast one hash has to be passed") unless config_hashes.size >= 1
      @hashes = config_hashes
      load_from_defn
    end
    
    def load_from_defn
      main_hash = @hashes.first
      reset(main_hash)
      @hashes[1..-1].each do |hash|
        partial_set(hash)
      end
      self
    end
    
    def reset(hash)
      keys.each{|key| delete(key)}
      hash.each do |key, value|
        set(key, value)
      end
      self
    end

    def prepare!
       each do |key, value|
         if value.kind_of?(Configula::Base)
           value.prepare!
         else
           self[key] = prepare_value(value)
         end
       end
      self
    end
    
    def prepare_value(value)
      case
      when value.kind_of?(String)
        interpolate(value)
      when value.kind_of?(Array)
        value.collect{|val| interpolate(val) }
      else
        value
      end
    end
    
    def partial_set(hash)
      hash.each do |key, value|
        if value.kind_of?(Hash)
          old_value = get(key)
          set(key, Configula::Base.empty_config) if( !(old_value.kind_of?(Base)) || old_value.nil?)
          get(key).partial_set(value)
        else
          set(key, value)
        end
      end
      self
    end

    def to_hash
      inject({}) do |hash, key_value|
        key, value = key_value
        hash.update(key => value.kind_of?(Base) ? value.to_hash : prepare_value(value))
      end
    end

    private
    def set(key, value)
      value_to_set = value.kind_of?(Hash) ? Base.prepare(value) : value
      self[key.to_s] = value_to_set
    end

    def get(key)
      prepare_value self[key.to_s]
    end

    def interpolate(value)
      return value unless value.kind_of?(String)
      value.gsub(/(\\\\)?\{\{([^\}]+)\}\}/) do
        escaped, pattern, key = $1, $2, $2.to_sym
        escaped ? pattern : eval(key.to_s)
      end
    end

    def method_missing(method_name, *args)
      method_name_string = method_name.to_s
      raise ConfigError.new("trying to change after preparing") if(method_name_string[-1,1] == '=' and !args.empty?)
      get(method_name)
    end

    include Store::AbstractStore
    
    private_instance_methods "[]="
  end
end