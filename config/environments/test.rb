# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

config.gem "rspec", :lib => false
config.gem "rspec-rails", :lib => false
config.gem "webrat", :lib => false
config.gem "machinist", :lib => false, :source => "http://gemcutter.org"
config.gem 'mocha'
config.gem 'launchy', :lib => false
config.gem "ZenTest" #Gives us access to autospec.
#See http://www.nateclark.com/articles/2008/09/17/_autotest_-is-now-_autospec_-how-to-set-up-autospec-for-rspec-and-rails-with-zentest
#rack-test is used for testing rack based apps.  See http://github.com/brynary/rack-test for details.
config.gem 'rack-test', :lib => false

config.after_initialize do
  #test
  Geocode.geocoder = Graticule.service(:google).new 'ABQIAAAAzMUFFnT9uH0xq39J0Y4kbhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR6j135zrztfTGVOm2QlWnkaidDIQ'
end