module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    # put all of your custom macros in here. See http://railscasts.com/episodes/157-rspec-matchers-macros
    # for more info
    def it_should_require_authentication_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require authentication" do
          # include the ID just in case the action needs it
          get action, :id => 1
          response.should redirect_to(login_path)
        end
      end
    end
  end
end