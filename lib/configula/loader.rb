module Configula
  class MetaConfig
    OPTIONS = [:store, :hashes, :yaml_files, :yaml_file_location]
    attr_accessor *OPTIONS
    
    def hashes
      return @hashes if @hashes
      @hashes = hashes_from_yaml_files
    end
    
    def yaml_file_location
      @yaml_file_location ||= File.join(RAILS_ROOT, "config", "configula")
    end
    
    private
    def hashes_from_yaml_files
      files = yaml_files || default_yaml_files
      files.collect do |file_name|
        YAML.load_file(config_file_path(file_name)) if config_file_exists?(file_name)
      end.compact
    end
    
    def default_yaml_files
      ["environment", RAILS_ENV]
    end
    
    def config_file_exists?(file_name)
      File.exists? config_file_path(file_name)
    end
    
    def config_file_path(file_name)
      file_name_with_extension = file_name.ends_with?(".yml") ? file_name : "#{file_name}.yml"
      File.join yaml_file_location, file_name_with_extension
    end
  end
  
  def self.load_config(meta_config)
    config = Base.prepare(*meta_config.hashes)
    config.store = meta_config.store
    begin
      config.load_from_store
    rescue Configula::Store::LoadFromStoreError => e
      config
    end
  end
  
  def self.prepare(&block)
    meta_config = MetaConfig.new
    yield(meta_config) if block
    load_config(meta_config)
  end
  
end