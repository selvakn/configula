## Configula without anystore ##
## -------------------------- ##
AppConfig = Configula.prepare


## With Yaml Store ##
## -------------- ##
# AppConfig = Configula.prepare do |config|
#   config.store = {
#     :name => Configula::Store::YamlStore,
#     :file => File.join(RAILS_ROOT, "config", "app_config.yml")
#   }
# end
