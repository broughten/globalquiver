class UserObserver < ActiveRecord::Observer
  
  def after_save(user)
    UserMailer.deliver_password_reset_notification(user) if user.password_recently_reset?
  end
end
