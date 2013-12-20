class DownloadsController < ApplicationController

  def new
    @download = Download.new
  end
  
  def create
    @download = Download.new(params[:download])
    @download.user_id = current_user.id
    if @download.save
      send_file @download.upload.asset.path
    end
  end
  
  def index
    @downloads = Upload.shared_with(current_user)
    @downloads = @downloads.uploaded_between(params[:start_date], params[:end_date]).page(params[:page]).per_page(25)
  end
  
  private
  
  def current_resource
    @current_resource ||= Upload.find(params[:upload_id]) if params[:upload_id]
  end

end