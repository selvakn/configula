class CommonConfig < Configula::Base
  self.persistance_options = {
    :store_name => Canfigula::Store::YamlStore, 
    :file => File.join(RAILS_ROOT, "config", "app_config.yml")
  }
  
  def initialize
    super
    self.config1 = "value1"
    self.config2 = "value2"
    self.config3 = ["value3.1", "value3.2"]
    self.config4 = {"sub_config4.1" => "value4.1", "sub_config4.2" => "value4.2"}
    
    self.config5.sub_config1 = "value5.1"
    self.config5.sub_config2 = "value5.2"
  end
end

class DevelopmentConfig < CommonConfig
  def initialize
    super
    self.config2 = "modified development"
  end
end

class TestConfig < CommonConfig
  def initialize
    super
    self.config2 = "modified test"
  end
end

class ProductionConfig < CommonConfig
  def initialize
    super
    self.config2 = "modified production"
  end
end

config_class = "#{RAILS_ENV.camelize}Config".constantize
AppConfig = config_class.load_config