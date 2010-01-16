module Admin
  class ConfigulaController < ApplicationController
    
    def update
      AppConfig.reset(JSON.parse(params["config"]))
      flash[:info] = "Config Prepared"

      begin
        AppConfig.persist
        flash[:info] << " And Persisted"
      rescue Configula::ConfigError => e
        flash[:error] = "Error '#{e.message}' while persisting"
      end
      
      redirect_to :action => :index
    end
  end
end