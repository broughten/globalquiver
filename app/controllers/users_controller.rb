class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  before_filter :login_required, :except => [:show, :new, :create, :lost_password, :reset_password]
  before_filter :get_partial_user_from_session, :only => [:new, :lost_password]
  after_filter :save_partial_user_in_session, :only => [:new, :lost_password]

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
    @existing_locations = current_user.locations
    
    @user = current_user
  end
  
  def update
    @user = current_user

    #need to figure out what type of object you are dealing with
    # since the form will populate the params based on that
    class_string = @user.class.to_s.downcase
    @image = Image.new(params[class_string][:image_attributes])
    
    if !@image.nil? && !@image.valid?
      render :action => :edit
    elsif @user.update_attributes(params[class_string])
      flash[:notice] = 'Profile successfully updated.'
      redirect_to(edit_user_path(:id =>  @user.id))
    else
      render :template => 'users/edit'
    end
  end

  def lost_password
   case request.method
   when :post
     @user = User.find_by_email(params[:user][:email])
     unless @user.blank?
       @user.create_password_reset_code
       flash[:notice] = "Reset code sent to #{params[:user][:email]}"
       redirect_back_or_default('/')
     else
       flash[:error] = "Please enter a valid email address"
     end
   when :get
     @user = User.new
   end
  end

  def reset_password
    @user = User.find_by_password_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if !@user
      flash[:error] = "Reset password token invalid, please contact support."
      redirect_to('/')
      return
    else
      @user.crypted_password = nil
    end
    if request.post?
     if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
       #self.current_user = @user
      @user.delete_password_reset_code
       flash[:notice] = "Password updated successfully for #{@user.email} - You may now log in using your new password."
       redirect_back_or_default('/')
     else
       render :action => :reset_password
     end
    end
  end


  private
    def get_partial_user_from_session
      unless session[:partial_user].nil?
        @user =  session[:partial_user]
      else
        @user = User.new
      end
    end

    def save_partial_user_in_session
      session[:partial_user] = @user
    end
end
