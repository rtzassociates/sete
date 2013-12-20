class UploadsController < ApplicationController
  def index
    @uploads = Upload.uploaded_between(params[:start_date], params[:end_date]).page(params[:page]).per_page(25)
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
    @upload = Upload.new(params[:upload])
    @upload.user = current_user
    @upload.save
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to @upload.user, :notice => "File deleted successfully"
  end

  def unshare
    @upload = Upload.find(params[:id])
    @user = User.find(params[:user_id])
    @upload.unshare_with(@user)
    @upload.save
    redirect_to @user, :notice => "File unshared successfully"
  end

  private
  
  def current_resource
    @current_resource ||= Upload.find(params[:id]) if params[:id]
  end

end