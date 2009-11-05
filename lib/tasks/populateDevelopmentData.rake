#require 'paperclip'

def create_images_for_board(board,photo_path)
  Dir.glob(photo_path).entries.each do |e|
    image = Image.new
    image.owner = board
    image.data = File.open(e)
    image.save!
  end
end

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
    require 'fileutils'
    
    #Clear out the tables
    [User, Board, Location, Style, Image, Geocode, Geocoding].each(&:delete_all)
    
    #Clear out the images folder to remove old images
   FileUtils.rm_rf RAILS_ROOT + '/public/system/datas/'
    
    #Set up User data
    surfer = Surfer.create(:first_name=>"Dev", :last_name=>"Surfer", :password=>"testing", 
      :password_confirmation=>"testing", :email=>"devsurfer@test.com", :terms_of_service=>"true")
    shop = Shop.create(:name=>"Dev Shop",   :password=>"testing", 
        :password_confirmation=>"testing", :email=>"devshop@test.com", :terms_of_service=>"true")
    emptySurfer = Surfer.create(:first_name=>"Empty", :last_name=>"Surfer", :password=>"testing", 
          :password_confirmation=>"testing", :email=>"emptysurfer@test.com", :terms_of_service=>"true")
    adminSurfer = Surfer.create(:first_name=>"Admin", :last_name=>"Surfer", :password=>"testing", 
                :password_confirmation=>"testing", :email=>"adminsurfer@test.com", :terms_of_service=>"true")
          
    # Set up Style data
    longboard = Style.create(:name=>"longboard")
    shortboard = Style.create(:name=>"shortboard")
    fish = Style.create(:name=>"Fish")
    
    #Set up location data
    surferLocation = BoardLocation.create(:street=>"233 W Micheltorena St", :locality=>"Santa Barbara", 
      :region=>"CA", :postal_code=>"93101", :country=>"USA", :creator=>surfer, :updater=>surfer)
    shopLocation = BoardLocation.create(:street=>"13005 Lowell Blvd", :locality=>"Westminster", 
        :region=>"CO", :postal_code=>"80031", :country=>"USA", :creator=>shop, :updater=>shop)
        
    # Set up some search locations
    SearchLocation.create(:locality=>"Santa Barbara", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"Westminster", :region=>"CO", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    
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
    
    counter = 0
    Board.find(:all).each do |board|
      create_images_for_board(board,'./spec/fixtures/images/boards/*') if (counter % 4 == 0)
      counter += 1
    end
    
    
  end
end