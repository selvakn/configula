module Admin
  class ConfigulaController < ApplicationController
    
    def update
      AppConfig.reset(JSON.parse(params["config"]))
      redirect_to :action => :index
    end
  end
end