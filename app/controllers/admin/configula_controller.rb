module Admin
  class ConfigulaController < ApplicationController
    
    def update
      AppConfig.reset(JSON.parse(params["config"]))
      flash[:info] = "Config Prepared"

      begin
        AppConfig.persist
        flash[:info] << " And Persisted in #{AppConfig.store[:name]}"
      rescue Configula::ConfigError => e
        flash[:error] = "Error '#{e.message}' while persisting"
      end
      
      redirect_to :action => :index
    end
    
    def reload_from_store
      AppConfig.load_from_defn
      flash[:info] = "Config Reloaded from Defintiion"
      redirect_to :action => :index
    end
  end
end