# Settings specified here will take precedence over those in config/environment.rb

# The staging environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Tell us if the mailer can't send
config.action_mailer.raise_delivery_errors = true

# Set delivery method to :smtp, :sendmail, or :test
config.action_mailer.delivery_method = :sendmail

# these options are only needed if you chose :smtp delivery
#config.action_mailer.smtp_settings = {
#  :address            => "smtp.engineyard.com",
#  :port               => 25,
#  :domain             => 'engineyard.com',
#  :authentication     => :login,
#  :username           => 'make@samyamatech.com',
#  :password           => 'broughten'
#}

# Enable threaded mode
# config.threadsafe!

config.after_initialize do
  #staging
  Geocode.geocoder = Graticule.service(:google).new 'ABQIAAAA1hU_SVFhmMhTRhqw95_GmRQhib7-JzilLwaGlEK_8GiJyKGYpBREKAjUwSQOs89fWk3n0p-3CAOQpw'
end