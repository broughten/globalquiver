# this associates the task into the db: namespace
namespace :db do
  # Always use one of these to allow a taks list to show this task
  desc "Erase and fill data with bogus, development data"
  
  # this creates a rake task called populat (db:populate) and passing in the environment
  # gives us access to all of our models.
  task :populateDevData => :environment do
    # populate your dev data here
    # see http://railscasts.com/episodes/126-populating-a-database for a good example
    # of how to do this
  end
end