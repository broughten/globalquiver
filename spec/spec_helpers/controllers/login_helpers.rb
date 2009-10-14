module ControllerHelpers
  def login_as_user
    user = User.make()
    controller.stubs(:current_user).returns(user)
  end
 
end