module ControllerHelpers
  def login_as_user
    @user = User.make()
    controller.stubs(:current_user).returns(@user)
  end

  def login_as_surfer
    @user = Surfer.make()
    controller.stubs(:current_user).returns(@user)
  end

  def login_as_admin
    @user = User.make()
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:admin?).returns(true)
  end
 
end