# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def env_ssl_protocol
    RAILS_ENV == 'production' ? 'https' : 'http'
  end

  def body_class
    if controller.respond_to?(:body_class)
      controller.send(:body_class)
    else
      "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
    end
  end

  
end
