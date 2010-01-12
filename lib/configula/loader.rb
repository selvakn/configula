module Configula
  class MetaConfig
    attr_accessor :store, :hashes, :yaml_file_location
    
    def yaml_files=(files)
      @hashes = files.collect do |file_name|
        file_name_with_extension = file_name.ends_with?(".yml") ? file_name : "#{file_name}.yml"
        file_path = File.join(yaml_file_location, file_name_with_extension)
        YAML.load_file(file_path)
      end
    end
    
    def hashes
      return @hashes if @hashes
      self.yaml_files = default_yaml_file_list
      @hashes
    end
    
    def default_yaml_file_list
      ["environment", RAILS_ENV]
    end
    
    def yaml_file_location
      @yaml_file_location ||= File.join(RAILS_ROOT, "config", "configula")
    end
  end
  
  def self.load_config
    extend_store(Base.new).load_from_store
  rescue Exception => e
    extend_store Base.prepare(*meta_config.hashes)
  end
  
  def self.prepare(&block)
    @meta_config = MetaConfig.new
    yield(@meta_config) if block
    load_config
  end
  
  def self.meta_config
    @meta_config
  end
  
  def self.extend_store(config)
    config.extend(meta_config.store[:name]) if meta_config.store and meta_config.store[:name]
    config
  end
end