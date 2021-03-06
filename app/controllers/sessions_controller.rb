class SessionsController < ApplicationController

  skip_before_filter :login_required, :only => [ :new, :create ]
  
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to_target_or_default current_user, :notice => "Logged in successfully"
    else
      flash.now[:error] = "Invalid login or password"
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_url, :notice => "You have been logged out"
  end
  
end