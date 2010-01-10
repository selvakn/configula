module Admin
  class ConfigulaController < ApplicationController
    def index
      render :json => AppConfig
    end
    
    def update
      params["config"].each do |key, value|
        AppConfig.set(key, value)
      end
      render :text => "Success"
    end
  end
end