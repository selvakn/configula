class Configula
  class ConfigError < StandardError
  end
  
  def inspect
    return "{}" if @configs.empty?
    
    val = @configs.sort.collect do |key, value| 
      "#{key.inspect} => #{value.inspect}"
    end.join(",\n")
    ["{", val, "}"].join("\n")
  end
  
  def self.prepare
    new.prepare!
  end
  
  def set(key, value)
    @configs[key.to_s] = value
  end
  
  def prepare!
    for value in @configs.values
      value.send("prepare!") if value.kind_of?(Configula)
    end
    @prepared = true
    @configs.each do |key, value|
      case
      when value.kind_of?(Proc)
        @configs[key] = value.call
      when value.kind_of?(String)
        @configs[key] = eval("%Q{#{value}}")
      end
    end
    self
  end
  
  alias defer lambda
  
  private
  def initialize
    @prepared = false
    @configs = {}
  end
  
  def prepared?
    @prepared
  end
  
  def get(key)
    @configs[key.to_s]
  end
  
  def exists?(key)
    !!@configs[key.to_s]
  end
  
  def method_missing(method_name, *args)
    if prepared?
      if args.empty?
        return get(method_name)
      else
        raise ConfigError.new("trying to change after preparing")
      end
    end
    
    # Multilevel Chaining
    if args.empty?
      return set(method_name, Configula.new) unless exists?(method_name)
      return get(method_name)
    end
    
    method_name = method_name.to_s
    method_name = method_name[-1,1] == '=' ? method_name[0..-2] : method_name
    set method_name, args.first
  end
end