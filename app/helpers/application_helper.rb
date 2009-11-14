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

  def static_page_keywords
    PagesController::PAGE_KEYWORDS
  end

  def active_class_if_current_tab(keyword)
    current_tab?(keyword) ? 'class="active"' : ''
  end

  def current_tab?(keyword)
    current_page?(page_path(keyword)) || tab_conditions(keyword).any?(&:call)
  end

  def tab_conditions(keyword)
    {
      :Home => [ lambda { current_page?(root_path) } ]
    }[keyword.to_sym] || []
  end

  
end
