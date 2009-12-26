class Configula
  @@prepared = false
  
  def self.prepared?
    @@prepared
  end
  
  def self.prepare
    config = new
    config.instance_variables.each do |name|
      actual_value = config.instance_variable_get(name)
      # config.instance_variable_set(name, actual_value.call) if actual_value.kind_of?(Proc)
    end
    
    @@prepared = true
    config
  end
  
  def self.reset
    @@prepared = false
  end
  
  def set(key, value)
    instance_variable_set "@#{key}", value
  end
  
  def get(key)
    instance_variable_get("@#{key}")
  end
  
  def method_missing(method_name, *args)
    return get(method_name) if args.empty? and self.class.prepared?
    raise "config value cannot be changed now" if self.class.prepared? # trying to set value after prepared
    
    # Multilevel Chaining
    if args.empty?
      new_config = Configula.new
      set method_name, new_config
      return new_config
    end
    
    
    # value = lambda do 
    #   val = args.first
    #   case
    #   when val.kind_of?(Proc)
    #     val.call
    #   else
    #     val
    #   end
    # end
    
    
    method_name = method_name.to_s
    method_name = method_name[-1,1] == '=' ? method_name[0..-2] : method_name
    
    set method_name, args.first
  end
  
end