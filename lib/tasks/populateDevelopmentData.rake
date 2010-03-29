#require 'paperclip'

def create_images_for_board(board,photo_path)
  4.times do
    
    image = Image.new
    image.owner = board
    image.data = File.open(Dir.glob(photo_path).entries.rand)
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
    [BoardSearch, User, UnavailableDate, Board, Location, Style, Image, Geocode, Geocoding, PickupTime, Reservation].each(&:delete_all)
    
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
    killerdana = Shop.create(:name=>"Killer Dana Surf Shop",   :password=>"testing",
      :password_confirmation=>"testing", :email=>"killerdana@test.com", :terms_of_service=>"true")
    shop = Shop.create(:name=>"Dev Shop",   :password=>"testing",
      :password_confirmation=>"testing", :email=>"devshop@test.com", :terms_of_service=>"true")
    hansens = Shop.create(:name=>"Hansen's Surf Shop",   :password=>"testing",
      :password_confirmation=>"testing", :email=>"hansens@test.com", :terms_of_service=>"true")
    emptySurfer = Surfer.create(:first_name=>"Empty", :last_name=>"Surfer", :password=>"testing", 
      :password_confirmation=>"testing", :email=>"emptysurfer@test.com", :terms_of_service=>"true")
    adminSurfer = Surfer.create(:first_name=>"Admin", :last_name=>"Surfer", :password=>"testing", 
      :password_confirmation=>"testing", :email=>"adminsurfer@test.com", :terms_of_service=>"true")

    #give Jordy, Kelly, and devSurfer images
    create_image_for_user(jordy, RAILS_ROOT + '/spec/fixtures/images/users/jordy.png')
    create_image_for_user(slater, RAILS_ROOT + '/spec/fixtures/images/users/slater.png')
    create_image_for_user(surfer, RAILS_ROOT + '/spec/fixtures/images/users/deSouza.png')

    #give killer dana an image
    create_image_for_user(killerdana, RAILS_ROOT + '/spec/fixtures/images/users/killerdana.png')


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
    
    #Set up location data
    surferLocation = BoardLocation.create(:street=>"233 W Micheltorena St", :locality=>"Santa Barbara", 
      :region=>"CA", :postal_code=>"93101", :country=>"USA", :creator=>surfer, :updater=>surfer)
    slaterLocation = BoardLocation.create(:street=>"108 Zamora St", :locality=>"St Augustine",
        :region=>"FL", :postal_code=>"32084", :country=>"USA", :creator=>slater, :updater=>slater)
    jordyLocation = BoardLocation.create(:street=>"5283 Los Robles Dr", :locality=>"Carlsbad",
        :region=>"CA", :postal_code=>"92008", :country=>"USA", :creator=>jordy, :updater=>jordy)
    shopLocation = BoardLocation.create(:street=>"1454 48th Ave", :locality=>"San Francisco",
        :region=>"CA", :postal_code=>"94122", :country=>"USA", :creator=>shop, :updater=>shop)
    killerdanaLocation = BoardLocation.create(:street=>"24470 Del Prado", :locality=>"Dana Point",
        :region=>"CA", :postal_code=>"92629", :country=>"USA", :creator=>killerdana, :updater=>killerdana)
    hansensLocation = BoardLocation.create(:street=>"1105 So Coast Highway 101", :locality=>"Encinitas",
        :region=>"CA", :postal_code=>"92024", :country=>"USA", :creator=>hansens, :updater=>hansens)

    # Set up some search locations
    SearchLocation.create(:locality=>"Santa Barbara", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"San Fransico", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"San Diego", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"St Augustine", :region=>"FL", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)
    SearchLocation.create(:locality=>"Dana Point", :region=>"CA", :country=>"USA",:search_radius=>100, :creator=>adminSurfer, :updater=>adminSurfer)

    #Set up boards for surfer
    SpecificBoard.populate 3 do |board|
      board.name = ['Art', 'Bobby', 'Child Seat', 'Dropper Inner', 'Eat Me', 'Franks Legend', 'Ghost Board', 'Hippy Board', 'It Board', 'Just a Board', 'Killer', 'Life', 'Manboard', 'No Name', 'Occys Revenge', 'Pounder', 'Quick', 'Rail Rider', 'Slopper', 'Tubs', 'Undermind', 'Velvet Sea', 'X', 'Your Board', 'Zoo Board'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [100, 120, 200].rand
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.description = Faker::Lorem.sentences(4)
      board.daily_fee = [0,30,40,50,20].rand
      board.creator_id = surfer.id
      board.updater_id = surfer.id
      board.location_id = surferLocation.id
      board.inactive = 0
    end

    #Set up 4 boards for slater
    SpecificBoard.populate 4 do |board|
      board.name = ['Art', 'Bobby', 'Child Seat', 'Dropper Inner', 'Eat Me', 'Franks Legend', 'Ghost Board', 'Hippy Board', 'It Board', 'Just a Board', 'Killer', 'Life', 'Manboard', 'No Name', 'Occys Revenge', 'Pounder', 'Quick', 'Rail Rider', 'Slopper', 'Tubs', 'Undermind', 'Velvet Sea', 'X', 'Your Board', 'Zoo Board'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [72, 70, 100, 74].rand
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.description = Faker::Lorem.sentences(4)
      board.daily_fee = [0,30,40,50,20].rand
      board.creator_id = slater.id
      board.updater_id = slater.id
      board.location_id = slaterLocation.id
      board.inactive = 0
    end

    #Set up 2 boards for jordy
    SpecificBoard.populate 2 do |board|
      board.name = ['Art', 'Bobby', 'Child Seat', 'Dropper Inner', 'Eat Me', 'Franks Legend', 'Ghost Board', 'Hippy Board', 'It Board', 'Just a Board', 'Killer', 'Life', 'Manboard', 'No Name', 'Occys Revenge', 'Pounder', 'Quick', 'Rail Rider', 'Slopper', 'Tubs', 'Undermind', 'Velvet Sea', 'X', 'Your Board', 'Zoo Board'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [72, 70, 100, 74].rand
      board.length = [72, 70]
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.daily_fee = [0,30,40,50,20].rand
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = jordy.id
      board.updater_id = jordy.id
      board.location_id = jordyLocation.id
      board.inactive = 0
    end
    
    #Set up boards for shop
    SpecificBoard.populate 10 do |board|
      board.name = ['1234123','1234124','1234125','1234126','1234127','1234128','1234129','1234130','1234131','1234132','1234133','1234134','1234135','1234136','1234137','1234138','1234139','1234140','1234141','1234142','1234143','1234144','1234145','1234146','1234147','1234148','1234149'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [72, 70, 100, 74].rand
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.daily_fee = [0,30,40,50,20].rand
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = shop.id
      board.updater_id = shop.id
      board.location_id = shopLocation.id
      board.inactive = 0
    end

    #Set up 50 boards for killer dana
    SpecificBoard.populate 50 do |board|
      board.name = ['1234123','1234124','1234125','1234126','1234127','1234128','1234129','1234130','1234131','1234132','1234133','1234134','1234135','1234136','1234137','1234138','1234139','1234140','1234141','1234142','1234143','1234144','1234145','1234146','1234147','1234148','1234149'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [72, 73, 71, 70, 100, 74, 75, 76, 77, 78, 79, 80].rand
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.daily_fee = [0,30,40,50,20].rand
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = killerdana.id
      board.updater_id = killerdana.id
      board.location_id = killerdanaLocation.id
      board.inactive = 0
    end

    #Set up 7 boards for hansens
    SpecificBoard.populate 7 do |board|
      board.name = ['1234123','1234124','1234125','1234126','1234127','1234128','1234129','1234130','1234131','1234132','1234133','1234134','1234135','1234136','1234137','1234138','1234139','1234140','1234141','1234142','1234143','1234144','1234145','1234146','1234147','1234148','1234149'].rand
      board.maker = ['Channel Islands', 'Firewire', 'Hurley'].rand
      board.model = ['Flyer', 'Flyer2', 'Fang', 'Kicker', 'Wave Hound', 'Kook', 'Lip Smasher', 'Meat Eater', 'RDS', 'WRB', 'Super Gun', 'Aloha', 'Aloha 2', 'Apple', 'Work Stinx', 'Sodo', 'Palm', "Banana", "Coconut", "Duck Dive", "Elephant Gun", "Front Runner", "Gore", "Hippie Stick", "Indio", "Jax Beach", "Kulani", "Lava", "Meteor", "Nugget", "Opal", "Pipon", "Quota", "Ride", "Style Ride", "Tube Tamer", "Uberboard", "Vega", "Winner", "Xyzzx", "Yuma", "Zoom Room" ].rand
      board.length = [72, 73, 71, 70, 100, 74, 75].rand
      board.style_id = [longboard.id, thruster.id, fish.id, gun.id, funboard.id, non_standard.id].rand
      board.daily_fee = [0,30,40,50,20].rand
      board.description = Faker::Lorem.sentences(4)
      board.creator_id = hansens.id
      board.updater_id = hansens.id
      board.location_id = hansensLocation.id
      board.inactive = 0
    end
    
    Board.find(:all).each_with_index do |board, index|
      create_images_for_board(board,RAILS_ROOT + '/spec/fixtures/images/boards/*')
    end
    
    Reservation.create(:creator=>surfer,:updater=>surfer,
      :board=>hansens.boards.first,:reserved_dates=>[UnavailableDate.create(:date=>2.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>3.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>5.days.from_now, :creator=>surfer, :updater=>surfer)])
        
    reservation = Reservation.create(:creator=>surfer,:updater=>surfer,
      :board=>hansens.boards.last,:reserved_dates=>[UnavailableDate.create(:date=>10.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>11.days.from_now, :creator=>surfer, :updater=>surfer),
      UnavailableDate.create(:date=>15.days.from_now, :creator=>surfer, :updater=>surfer)])
    
    Invoice.create(:responsible_user=>shop, :due_date=>30.days.from_now, :reservations=>[reservation])
    
  end
end