# this associates the task into the db: namespace
namespace :db do
  # Always use one of these to allow a taks list to show this task
  desc "Erase and fill database with development data"
  
  # this creates a rake task called populat (db:populate) and passing in the environment
  # gives us access to all of our models.
  task :populateDevData => :environment do
    # populate your dev data here
    # see http://railscasts.com/episodes/126-populating-a-database for a good example
    # of how to do this
    require 'populator'
    require 'faker'
    
    #Clear out the tables
    [User, Board, Location, Style, Image, Geocode, Geocoding].each(&:delete_all)
    
    #Set up User data
    surfer = Surfer.create(:first_name=>"Dev", :last_name=>"Surfer", :password=>"testing", 
      :password_confirmation=>"testing", :email=>"devsurfer@test.com", :terms_of_service=>"true")
    shop = Shop.create(:name=>"Dev Shop",   :password=>"testing", 
        :password_confirmation=>"testing", :email=>"devshop@test.com", :terms_of_service=>"true")
    emptySurfer = Surfer.create(:first_name=>"Empty", :last_name=>"Surfer", :password=>"testing", 
          :password_confirmation=>"testing", :email=>"emptysurfer@test.com", :terms_of_service=>"true")
          
    # Set up Style data
    longboard = Style.create(:name=>"longboard")
    shortboard = Style.create(:name=>"shortboard")
    fish = Style.create(:name=>"Fish")
    
    #Set up location data
    surferLocation = Location.create(:street=>"233 W Micheltorena St", :locality=>"Santa Barbara", 
      :region=>"CA", :postal_code=>"93101", :country=>"USA", :creator=>surfer, :updater=>surfer)
    shopLocation = Location.create(:street=>"13005 Lowell Blvd", :locality=>"Westminster", 
        :region=>"CO", :postal_code=>"80031", :country=>"USA", :creator=>shop, :updater=>shop)
        
    #Set up boards for surfer
    Board.populate 3 do |board|
      board.maker = Faker::Company.name
      board.model = Faker::Lorem.words(1)
      board.length = [100, 120, 200]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = surfer.id
      board.updater_id = surfer.id
      board.location_id = surferLocation.id
    end
    
    #Set up boards for shop
    Board.populate 10 do |board|
      board.maker = Faker::Company.name
      board.model = Faker::Lorem.words(1)
      board.length = [100, 120, 200]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = shop.id
      board.updater_id = shop.id
      board.location_id = shopLocation.id
    end
  end
end