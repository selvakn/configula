<% if store == "NoStore" -%>
AppConfig = Configula.prepare
<% elsif store == "YamlStore" -%>
AppConfig = Configula.prepare do |config|
  config.store = {
    :name => Configula::Store::YamlStore,
    :file => File.join(RAILS_ROOT, "config", "app_config.yml")
  }
end
<% elsif store == "DBStore" -%>
AppConfig = Configula.prepare do |config|
  config.store = {
    :name => Configula::Store::DBStore,
  }
end
<% end -%>