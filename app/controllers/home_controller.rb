class HomeController < ApplicationController
  skip_before_filter :login_required
  
  def index
    if logged_in?
      redirect_to downloads_path
    else
      redirect_to new_session_path
    end
  end

end