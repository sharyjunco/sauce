class PhotosController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy]
  
  caches_page :index, :photo, :collection

  def index
    @collections = PhotoCollection.find(:all).select{|collection| collection.url.count('/') == 0}
  end
  
  def photo
    return collection if !@photo && !@photo = Photo.find_by_url(params[:path].join('/').gsub(/\.html$/,''),:include => [:photo_tags,:photo_collection])
    @collection = @photo.photo_collection
    @previous_collection = @collection.previous
    @next_collection = @collection.next
    @next_photo = @photo.next
    @previous_photo = @photo.previous
  end
  
  def collection
    return no_collection_or_photo if !@collection = PhotoCollection.find_by_url(params[:path].join('/'))
    if(@collection_index_partial = collection_index_partial(@collection))
      @previous_collection = @collection.previous
      @next_collection = @collection.next
      render :action => :collection
    else
      @photo = @collection.photos.first
      if @photo
        photo
      else
        render :action => :photo_missing
      end
    end
  end
  
  def no_collection_or_photo
    render :action => 'photo_missing'
  end
  
  def update
    @page_list = page_list
    @page_list.each do |page|
      path = page[:path]
      page.delete :path
      expire_page(url_for(page) + (path ? '/' + path.join('/') : ''))
    end
    @actions = Photo.update
    render :action => 'update', :layout => false
  end
  
  protected
  
  def page_list
    collection_pages = PhotoCollection.find(:all).collect do |collection|
      {:action => :index, :controller => :photos, :path => collection.url.split('/')}
    end
    photo_pages = Photo.find(:all).collect do |photo|
      {:action => :index, :controller => :photos, :path => photo.url.split('/')}
    end
    [{:action => :index, :controller => :photos}].concat(collection_pages).concat(photo_pages)
  end
  
  def collection_index_partial(collection)
    collection_bits = collection.path.split('/')
    collection_bits[collection_bits.length - 1] = '_' + collection_bits[collection_bits.length - 1]
    if File.exists?(RAILS_ROOT + '/app/views/photos/collections/' + collection_bits.join('/') + '.rhtml')
      'photos/collections/' + collection.path
    else
      false
    end
  end
end