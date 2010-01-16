ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.connect 'configula', :action => "index", :controller => "configula", :conditions => {:method => :get}
    admin.connect 'configula', :action => "update", :controller => "configula", :conditions => {:method => :post}
  end
end
