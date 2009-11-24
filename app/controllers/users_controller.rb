class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :login_required, :except => [:new, :create]

  # render new.rhtml
  def new
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def create
    cookies.delete :auth_token

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
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    #need to figure out what type of object you are dealing with
    # since the form will populate the params based on that
    class_string = @user.class.to_s.downcase   
    if @user.update_attributes(params[class_string])
      flash[:notice] = 'Profile successfully updated.'
      redirect_to(edit_user_path(:id =>  @user.id))
    else
      render :action => "edit"
    end
  end

end
