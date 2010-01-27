
# this associates the task into the db: namespace
namespace :db do
  # Always use one of these to allow a taks list to show this task
  desc "Erase and fill database with production data"
  
  # this creates a rake task called populat (db:populate) and passing in the environment
  # gives us access to all of our models.
  task :populateProdData => :environment do
    # populate your prod data here
    # see http://railscasts.com/episodes/126-populating-a-database for a good example
    # of how to do this
    require 'populator'
    require 'faker'
    require 'fileutils'
    
    #Clear out the tables
    [BoardSearch, User, UnavailableDate, Board, Location, Style, Image, Geocode, Geocoding, PickupTime, Reservation].each(&:delete_all)
    
    #Clear out the images folder to remove old images
   FileUtils.rm_rf RAILS_ROOT + '/public/system/datas/'
    
    morning = PickupTime.create(:name => "Morning")
    afternoon = PickupTime.create(:name => "Afternoon")
    evening = PickupTime.create(:name => "Evening")
    by_appt = PickupTime.create(:name => "By Appointment")

    # Set up Style data
    longboard = Style.create(:name=>"longboard")
    thruster = Style.create(:name=>"thruster")
    fish = Style.create(:name=>"fish")
    gun = Style.create(:name=>"gun")
    funboard = Style.create(:name=>"funboard")
    non_standard = Style.create(:name=>"non-standard")
  end
end