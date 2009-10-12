module ControllerHelpers
  def login_as_user
    controller.stubs(:logged_in?).returns(true)
  end
end