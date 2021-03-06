class PhotosController < ApplicationController
  def show
    @photo = Photo.find params[:id]
  end

  def edit
    @photo = Photo.find params[:id]
    redirect_to user_path(photo.user_id) unless @current_user.id == @photo.user_id.to_i
  end

  def update
    photo = Photo.find params[:id]
    cloudinary = Cloudinary::Uploader.upload(params["photo"]["image"])
    photo.image = cloudinary["url"]
    photo.save
    redirect_to user_path(@current_user.id)
  end

  def new
    @photo = Photo.new
  end

  def create
    cloudinary = Cloudinary::Uploader.upload(params["photo"]["image"])
    @photo = Photo.new photo_params
    @photo.user_id = @current_user.id
    @photo.image =cloudinary["url"]
    @photo.save
    redirect_to user_path(@current_user.id)
  end


  def destroy
    photo = Photo.find params[:id]
    photo.destroy
    redirect_to root_path
  end

  private
  def photo_params
    params.require(:photo).permit(:image, :user_id)
  end

end
