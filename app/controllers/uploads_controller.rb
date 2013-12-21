class UploadsController < ApplicationController

  def index
    @user = User.find_by_slug(params[:id])
    @uploads = @user.uploads.uploaded_between(params[:start_date], params[:end_date]).page(params[:page]).per_page(25)
  end
  
  def show
    @upload = Upload.find(params[:id])
    @downloads = @upload.downloads
  end

  def new
    @upload = Upload.new
  end
  
  def edit
    @upload = Upload.find(params[:id])
    @allowed_recipients = current_user.allowed_recipients
  end 
  
  def update
    @upload = Upload.find(params[:id])
    @upload.update_attributes(params[:upload])
    if @upload.save
      redirect_to @upload.user, :notice => "File shared successfully"
    else
      render 'edit'
    end
  end

  def create
    @user = User.find(params[:upload][:user_id])
    @upload = Upload.new(params[:upload])
    @upload.user = current_user
    @upload.save
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    if current_user.admin? && @upload.user != current_user
      path = "/users/#{@upload.user.slug}/uploads/"
    else
      path = @upload.user
    end
    redirect_to path, :notice => "File deleted successfully"
  end

  def unshare
    @upload = Upload.find(params[:id])
    @user = User.find_by_slug(params[:user_id])
    @upload.unshare_with(@user)
    @upload.save
    redirect_to @user, :notice => "File unshared successfully"
  end

  private
  
  def current_resource
    unless params[:action] == "index"
      @current_resource ||= Upload.find(params[:id]) if params[:id]
    end
  end

end