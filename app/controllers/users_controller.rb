class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session

    #figure out what type of user we need to make    
    if params[:is_shop] == 'yes'
      @user = Shop.new(params[:user])
    else
      @user = Surfer.new(params[:user])
    end
    if @user.save
      self.current_user = @user
      redirect_back_or_default(root_path)
      flash[:notice] = "Thanks for signing up!"
    else
      # we need to render the form here so we get the error
      # messages to display.  If we do a redirect, then the
      # error messages dissapear.
      render :action => :new
    end
  end

end
