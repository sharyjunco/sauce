class PhotosController < ApplicationController
  include ApplicationHelper
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
      elsif @collection.children.first && @collection.children.first.photos.first
        redirect_to collection_url(@collection.children.sort_by(&:name).first)
      else
        render :action => :photo_missing
      end
    end
  end
  
  def no_collection_or_photo
    render :action => 'photo_missing'
  end
    
  protected
    
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