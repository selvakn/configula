class Configula
  
  def initialize
    @prepared = false
    @configs = {}
  end
  
  def inspect
    return "not yet prepared" unless prepared?
    return "{}" if @configs.empty?
    
    val = @configs.sort.collect do |key, value| 
      "#{key.inspect} => #{value.inspect}"
    end.join(",\n")
    ["{", val, "}"].join("\n")
  end
  
  def prepared?
    @prepared
  end
  
  def prepare!
    for value in @configs.values
      value.prepare! if value.kind_of?(Configula)
    end
    @prepared = true
    @configs.each do |key, value|
      @configs[key] = value.call if value.kind_of?(Proc)
    end
    self
  end
  
  def self.prepare
    new.prepare!
  end
  
  def set(key, value)
    @configs[key.to_s] = value
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
        raise "trying to change after preparing noodles. daai.. test azuthuda!!" if !args.empty? and prepared?
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