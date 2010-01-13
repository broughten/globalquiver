#require 'paperclip'

def create_images_for_board(board,photo_path)
  Dir.glob(photo_path).entries.each do |e|
    image = Image.new
    image.owner = board
    image.data = File.open(e)
    image.save!
  end
end

def create_image_for_user(user,photo_path)
    image = Image.new
    image.owner = user
    image.data = File.open(photo_path)
    image.save!
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
    [User, Board, Location, Style, Image, Geocode, Geocoding, PickupTime, Reservation].each(&:delete_all)
    
    #Clear out the images folder to remove old images
   FileUtils.rm_rf RAILS_ROOT + '/public/system/datas/'
    
    #Set up User data
    surfer = Surfer.create(:first_name=>"Dev", :last_name=>"Surfer", :password=>"testing", 
      :password_confirmation=>"testing", :email=>"devsurfer@test.com", :terms_of_service=>"true")
    #we can't actually set the admin flag with the app.  Has to be manually set in the database
    admin = Surfer.create(:first_name=>"Admin", :last_name=>"Surfer", :password=>"testing",
      :password_confirmation=>"testing", :email=>"admin@test.com", :terms_of_service=>"true")
    slater = Surfer.create(:first_name=>"Kelly", :last_name=>"Slater", :password=>"testing",
      :password_confirmation=>"testing", :email=>"slater@test.com", :terms_of_service=>"true")
    jordy  = Surfer.create(:first_name=>"Jordy", :last_name=>"Smith", :password=>"testing",
      :password_confirmation=>"testing", :email=>"jordy@test.com", :terms_of_service=>"true")
    shop = Shop.create(:name=>"Dev Shop",   :password=>"testing", 
        :password_confirmation=>"testing", :email=>"devshop@test.com", :terms_of_service=>"true")
    hansens = Shop.create(:name=>"Hansen's Surf Shop",   :password=>"testing",
        :password_confirmation=>"testing", :email=>"hansens@test.com", :terms_of_service=>"true")
    killerdana = Shop.create(:name=>"Killer Dana Surf Shop",   :password=>"testing",
        :password_confirmation=>"testing", :email=>"killerdana@test.com", :terms_of_service=>"true")
    emptySurfer = Surfer.create(:first_name=>"Empty", :last_name=>"Surfer", :password=>"testing", 
          :password_confirmation=>"testing", :email=>"emptysurfer@test.com", :terms_of_service=>"true")
    adminSurfer = Surfer.create(:first_name=>"Admin", :last_name=>"Surfer", :password=>"testing", 
                :password_confirmation=>"testing", :email=>"adminsurfer@test.com", :terms_of_service=>"true")

    #give Jordy, Kelly, and devSurfer images
    create_image_for_user(jordy, RAILS_ROOT + '/spec/fixtures/images/users/jordy.png')
    create_image_for_user(slater, RAILS_ROOT + '/spec/fixtures/images/users/slater.png')
    create_image_for_user(surfer, RAILS_ROOT + '/spec/fixtures/images/users/deSouza.png')


    morning = PickupTime.create(:name => "Morning")
    afternoon = PickupTime.create(:name => "Afternoon")
    evening = PickupTime.create(:name => "Evening")
    by_appt = PickupTime.create(:name => "By Appointment")


    # Set up Style data
    longboard = Style.create(:name=>"longboard")
    shortboard = Style.create(:name=>"shortboard")
    fish = Style.create(:name=>"fish")
    
    #Set up location data
    surferLocation = BoardLocation.create(:street=>"233 W Micheltorena St", :locality=>"Santa Barbara", 
      :region=>"CA", :postal_code=>"93101", :country=>"USA", :creator=>surfer, :updater=>surfer)
    slaterLocation = BoardLocation.create(:street=>"108 Zamora St", :locality=>"St Augustine",
        :region=>"FL", :postal_code=>"32084", :country=>"USA", :creator=>slater, :updater=>slater)
    jordyLocation = BoardLocation.create(:street=>"5283 Los Robles Dr", :locality=>"Carlsbad",
        :region=>"CA", :postal_code=>"92008", :country=>"USA", :creator=>jordy, :updater=>jordy)
    shopLocation = BoardLocation.create(:street=>"13005 Lowell Blvd", :locality=>"Westminster",
        :region=>"CO", :postal_code=>"80031", :country=>"USA", :creator=>shop, :updater=>shop)
    killerdanaLocation = BoardLocation.create(:street=>"24470 Del Prado", :locality=>"Dana Point",
        :region=>"CA", :postal_code=>"92629", :country=>"USA", :creator=>killerdana, :updater=>killerdana)
    hansensLocation = BoardLocation.create(:street=>"1105 So Coast Highway 101", :locality=>"Encinitas",
        :region=>"CA", :postal_code=>"92024", :country=>"USA", :creator=>hansens, :updater=>hansens)

    # Set up some search locations
    SearchLocation.create(:locality=>"Santa Barbara", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"Westminster", :region=>"CO", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"San Diego", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"St Augustine", :region=>"FL", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"Dana Point", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)

    #Set up boards for surfer
    Board.populate 3 do |board|
      board.name = Faker::Company.name
      board.maker = ['Channel Islands', 'Firewire', 'Hurley']
      board.model = Faker::Lorem.words(1)
      board.length = [100, 120, 200]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.description = Faker::Lorem.sentences(4)
      board.daily_fee = ["$0.00","$20.00","$30.00","$40.00","$50.00"]
      board.creator_id = surfer.id
      board.updater_id = surfer.id
      board.location_id = surferLocation.id
      board.inactive = 0
    end

    #Set up 4 boards for slater
    Board.populate 4 do |board|
      board.name = Faker::Company.name
      board.maker = ['Channel Islands', 'Firewire', 'Hurley', 'Hobie']
      board.model = Faker::Lorem.words(1)
      board.length = [72, 70, 100, 74]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.description = Faker::Lorem.sentences(4)
      board.daily_fee = ["$0.00","$20.00","$30.00","$40.00","$50.00"]
      board.creator_id = slater.id
      board.updater_id = slater.id
      board.location_id = slaterLocation.id
      board.inactive = 0
    end

    #Set up 2 boards for jordy
    Board.populate 2 do |board|
      board.name = Faker::Company.name
      board.maker = ['Channel Islands', 'Firewire']
      board.model = Faker::Lorem.words(1)
      board.length = [72, 70]
      board.style_id = [shortboard.id, fish.id]
      board.daily_fee = ["$0.00","$20.00","$30.00","$40.00","$50.00"]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = jordy.id
      board.updater_id = jordy.id
      board.location_id = jordyLocation.id
      board.inactive = 0
    end
    
    #Set up boards for shop
    Board.populate 10 do |board|
      board.name = Faker::Company.name
      board.maker = ['Hobie', 'Gordon & Smith', 'T&C Surf Designs', 'BIC Sport', 'Wave Riding Vehicles', 'Rusty', 'Proctor Surfboards', 'Bear Surfboards', 'Yater Surfboards', 'Aloha Surfboards']
      board.model = Faker::Lorem.words(1)
      board.length = [100, 120, 200]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.daily_fee = ["$0.00","$20.00","$30.00","$40.00","$50.00"]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = shop.id
      board.updater_id = shop.id
      board.location_id = shopLocation.id
      board.inactive = 0
    end

    #Set up 50 boards for killer dana
    Board.populate 50 do |board|
      board.name = Faker::Company.name
      board.maker = ['Hobie', 'Gordon & Smith', 'T&C Surf Designs', 'BIC Sport', 'Wave Riding Vehicles', 'Rusty', 'Proctor Surfboards', 'Bear Surfboards', 'Yater Surfboards', 'Aloha Surfboards']
      board.model = Faker::Lorem.words(1)
      board.length = [72, 73, 71, 70, 100, 74, 75, 76, 77, 78, 79, 80]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.daily_fee = ["$20.00","$30.00","$40.00","$50.00"]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = killerdana.id
      board.updater_id = killerdana.id
      board.location_id = killerdanaLocation.id
      board.inactive = 0
    end

    #Set up 7 boards for hansens
    Board.populate 7 do |board|
      board.name = Faker::Company.name
      board.maker = ['Hobie', 'Gordon & Smith', 'Rusty', 'Proctor Surfboards', 'Bear Surfboards', 'Yater Surfboards', 'Aloha Surfboards']
      board.model = Faker::Lorem.words(1)
      board.length = [72, 73, 71, 70, 100, 74, 75]
      board.style_id = [longboard.id, shortboard.id, fish.id]
      board.daily_fee = ["$20.00","$30.00","$40.00","$50.00"]
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = hansens.id
      board.updater_id = hansens.id
      board.location_id = hansensLocation.id
      board.inactive = 0
    end
    
    Board.find(:all).each_with_index do |board, index|
      create_images_for_board(board,RAILS_ROOT + '/spec/fixtures/images/boards/*') if (index % 4 == 0)
    end
    
    Reservation.create(:creator=>surfer,:updater=>surfer,
      :board=>hansens.boards.first,:reserved_dates=>[UnavailableDate.create(:date=>2.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>3.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>5.days.from_now, :creator=>surfer, :updater=>surfer)])
        
    Reservation.create(:creator=>surfer,:updater=>surfer,
      :board=>hansens.boards.last,:reserved_dates=>[UnavailableDate.create(:date=>10.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>11.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>15.days.from_now, :creator=>surfer, :updater=>surfer)])
    
    
  end
end