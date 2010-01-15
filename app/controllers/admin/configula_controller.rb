module Admin
  class ConfigulaController < ApplicationController
    def index
      render :json => AppConfig
    end
    
    def update
      AppConfig.reset(params["config"])
      redirect_to :action => :index
    end
  end
end