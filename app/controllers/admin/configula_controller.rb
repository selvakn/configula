module Admin
  class ConfigulaController < ApplicationController
    def index
      render :json => AppConfig
    end
    
    def update
      AppConfig.reset(params["config"])
      index
    end
  end
end