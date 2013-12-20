class UsersController < ApplicationController

  def index
    @users = User.search(params[:search]).page(params[:page]).per_page(25)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, :notice => "User was successfully created"
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = @user.is?(current_user) ? "My Account" : @user.name    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])

      flash[:notice] = "Account was successfully updated"
      
      if @user.is?(current_user)
        redirect_to current_user
      else
        redirect_to users_path
      end
    else
      render :action => 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.is?(current_user) ? "Upload Files" : @user.name
    @upload = Upload.new
    if current_user.admin?
      @uploads = @user.uploads
    else
      @uploads = @user.is?(current_user) ? @user.uploads : current_user.uploads.shared_with(@user)
    end
    @uploads = @uploads.uploaded_between(params[:start_date], params[:end_date]).page(params[:page]).per_page(25)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, :notice => "User was successfully destroyed"
  end

  private
  
  def current_resource
    @current_resource ||= User.find(params[:id]) if params[:id]
  end
  
end
