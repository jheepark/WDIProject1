class ArtworksController < ApplicationController
  before_action :check_if_logged_in, :only => [:edit, :show]
  def index
    @artworks = Artwork.all
  end

  def show
    @artwork = Artwork.find params[:id]
    @comments = @artwork.comments
    @comment = Comment.new
    @like = Like.new
    @alreadyLiked = false
  end

  def edit
    @artwork = Artwork.find params[:id]
    redirect_to user_path(artwork.user_id) unless @current_user.id == @artwork.user_id.to_i
  end

  def update
    artwork = Artwork.find params[:id]
    cloudinary = Cloudinary::Uploader.upload(params["artwork"]["image"])
    artwork.image = cloudinary["url"]
    artwork.save
    redirect_to user_path(@current_user.id)
  end

  def new
    @artwork = Artwork.new
  end

  def create
    cloudinary = Cloudinary::Uploader.upload(params["artwork"]["image"])
    @artwork = Artwork.new artwork_params
    @artwork.user_id = @current_user.id
    @artwork.photo_id = params[:photo_id]
    @artwork.image = cloudinary["url"]
    @artwork.save
    redirect_to user_path(@artwork.user_id)
  end

  def destroy
    artwork = Artwork.find params[:id]
    artwork.destroy
    redirect_to user_path(@current_user.id)
  end

  private
  def artwork_params
    params.require(:artwork).permit(:image, :user_id, :photo_id)
  end

end
