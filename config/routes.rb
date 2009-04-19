ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'photos', :action => 'index'
  map.connect 'update', :controller => 'photos', :action => 'update'
  map.connect 'photos', :controller => 'photos', :action => 'index'
  map.connect 'photos/*path', :controller => 'photos', :action => 'photo'
end
