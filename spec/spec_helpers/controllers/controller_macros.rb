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

          if action == "new"
            get action
          end
          if action == "create"
            post action
          end
          if action == "edit"
            get action, :id => "1"
          end
          if action == "update"
            put action, :id => ""
          end
          response.should redirect_to(login_path)
        end
      end
    end

    def it_should_require_admin_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin" do
          get action, :id => 1
          response.should redirect_to(root_path)
        end
      end
    end
  end
end