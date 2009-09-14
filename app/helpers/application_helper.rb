# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def env_ssl_protocol
    RAILS_ENV == 'production' ? 'https' : 'http'
  end

  # Nested layouts, see: http://fora.pragprog.com/rails-recipes/write-your-own/post/144
#  def inside_layout(layout, &block)
#    @template.instance_variable_set("@content_for_layout", capture(&block))
#
#    layout = layout.to_s.include?("/") ? layout : "layouts/#{layout}" if layout
#    buffer = eval("_erbout", block.binding)
#    buffer.concat(@template.render(:file => layout))
#  end

  def body_class
    if controller.respond_to?(:body_class)
      controller.send(:body_class)
    else
      "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
    end
  end

  def signup_or_login_page?
    %w(session users).any? { |name| controller.class.name.downcase.include?(name) }
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
      :home       => [ lambda { current_page?(root_path)             } ],
      :about      => [ lambda { current_page?(page_path(:terms))     } ],
      :my_account => [ lambda { ! %w(admin pages).any?{ |prefix| @controller.controller_path =~ /^#{prefix}/ }} ],
      :admin      => [ lambda { @controller.controller_path =~ /^admin/ } ]
    }[keyword.to_sym] || []
  end

  def more_than_one(collection)
    collection.length > 0 ? 's' : ''
  end
  
end
