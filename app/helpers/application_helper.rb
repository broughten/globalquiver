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

  def active_if_current_tab(keyword)
    current_tab?(keyword) ? ' active' : ''
  end

  def needs_sidebar?
    if current_tab?("About") || current_tab?("Blog") || current_tab?("FAQ")
      return false
    else
      return true
    end
  end

  def current_tab?(keyword)
    current_page?(page_path(keyword)) || tab_conditions(keyword).any?(&:call)
  end

  def tab_conditions(keyword)
    {
      :Home => [ lambda { current_page?(root_path)         } ],
      :Find => [ lambda { current_page?(new_board_search_path) } ],
      :Add  => [ lambda { current_page?(new_board_path)    } ]
    }[keyword.to_sym] || []
  end

  def show_left_nav
    !((current_tab?('Home') && !logged_in?) || 
       current_page?(page_path('twitter'))  ||
       current_page?(login_path)            ||
       current_page?(new_session_path)      ||
       current_page?(new_user_path))
  end
  
  def google_analytics_id
    APP_CONFIG['google_analytics_account']
  end

  def shorten (string, count = 30)
    if string.length >= count
      shortened = string[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words-1].join(" ") + ' ...'
    else
      string
    end
  end


  
end
