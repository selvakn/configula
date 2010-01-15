module Configula
  class MetaConfig
    OPTIONS = [:store, :hashes, :yaml_file_location]
    attr_accessor *OPTIONS
    
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
  
  def self.load_config(meta_config)
    config = Base.new
    config.store = meta_config.store
    config.load_from_store
  rescue Configula::Store::LoadFromStoreError => e
    Base.prepare(*meta_config.hashes)
  ensure
    
  end
  
  def self.prepare(&block)
    meta_config = MetaConfig.new
    yield(meta_config) if block
    load_config(meta_config)
  end
  
end