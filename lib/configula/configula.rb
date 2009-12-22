class Configula
  @@locked = false
  
  def self.locked?
    @@locked
  end
  
  def self.lock
    @@locked = true
  end
  
  def self.unlock
    @@locked = false
  end
  
  def set(key, value)
    send("#{key}=", value)
  end
  
  def method_missing(method_name, *args)
    return if args.empty? and self.class.locked? # trying to read after locking
    raise "config locked" if self.class.locked? # trying to set value after locking
    
    
    if args.empty?
      new_config = Configula.new
      (class <<self; self; end).send(:define_method, method_name, lambda { new_config })
      return new_config
    end
    
    value = lambda do 
      val = args.first
      case
      when val.kind_of?(Proc)
        val.call
      else
        val
      end
    end
    
    method_name = method_name.to_s
    method_name = method_name[-1,1] == '=' ? method_name[0..-2] : method_name
    
    (class <<self; self; end).send(:define_method, method_name, value)
  end
end