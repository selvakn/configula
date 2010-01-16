ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.connect 'configula', :action => "index", :controller => "configula", :conditions => {:method => :get}
    admin.connect 'configula', :action => "update", :controller => "configula", :conditions => {:method => :post}

    admin.load_config_from_defn 'configula/reload_from_definition', :action => "reload_from_store", :controller => "configula"
  end
end
