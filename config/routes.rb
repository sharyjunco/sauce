ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'photos', :action => 'index'
  map.connect 'photos', :controller => 'photos', :action => 'index'
  map.connect 'photos/*path', :controller => 'photos', :action => 'photo'
  map.connect 'admin/:action', :controller => 'admin'
end
