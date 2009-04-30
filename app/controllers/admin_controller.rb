class AdminController < ApplicationController
  before_filter :ensure_user_is_admin
  
  def insert_at
    Photo.find(params[:id]).insert_at(params[:position])
  end
  
  def clear
    expire_all_cached_pages
    [Photo,PhotoCollection,PhotoTag,PhotoTagging].each do |model|
      model.find(:all).each &:destroy
    end
    update
  end
  
  def update
    expire_all_cached_pages
    @actions = Photo.update
    render :action => 'update', :layout => false
  end
  
  protected
  
  def expire_all_cached_pages
    @page_list = page_list
    @page_list.each do |page|
      path = page[:path]
      page.delete :path
      expire_page(url_for(page) + (path ? '/' + path.join('/') : ''))
    end
  end
  
  def page_list
    collection_pages = PhotoCollection.find(:all).collect do |collection|
      {:action => :index, :controller => :photos, :path => collection.url.split('/')}
    end
    photo_pages = Photo.find(:all).collect do |photo|
      {:action => :index, :controller => :photos, :path => photo.url.split('/')}
    end
    [{:action => :index, :controller => :photos}].concat(collection_pages).concat(photo_pages)
  end
  
  def ensure_user_is_admin
    logger.info session[:admin] ? 'User is admin.' : 'User is not admin.'
    session[:admin]
  end
end