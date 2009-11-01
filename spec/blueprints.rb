#Should be in every blueprints file.
require 'machinist/active_record'#http://github.com/notahat/machinist/
require 'sham' #see machinist
require 'faker' #http://faker.rubyforge.org/


#Set up the shams
# The ones without a block will look for sham definitions of the same name
Sham.define do
  email { Faker::Internet.email }
  first_name  { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  group_name {Faker::Lorem.words(2)}
  shop_name {Faker::Company.name}
  board_maker {Faker::Company.name}
  board_model {Faker::Lorem.words(1)}
  board_description {Faker::Lorem.words(10)}
  board_construction {Faker::Lorem.words(1)}
  location_street {Faker::Address.street_address()}
  location_city {Faker::Address.city()}
  location_state {Faker::Address.us_state()}
  location_postal_code {Faker::Address.zip_code()}
  style_name {Faker::Lorem.words(1)}
end

Sham.future_date do
  (1..100).to_a.rand.days.from_now
end

# Start of blueprints for user hierarchy.
# Subclass blueprints will first populate their attributes
# And then look to their parent blueprint for the missing attributes
Surfer.blueprint() do
  first_name
  last_name
end

Shop.blueprint() do
  name {Sham.shop_name}
end

User.blueprint() do
  email
  password {"good_password"}
  password_confirmation {password}
  terms_of_service {true}
  image {Image.make()}
end
# End of user hierarchy blueprints

Location.blueprint() do
  user = User.make()
  street {Sham.location_street}
  locality {Sham.location_city}
  region {Sham.location_state}
  postal_code {Sham.location_postal_code}
  country {"USA"}
  creator {user}
  updater {user}
end

#Use the next two locations to get geocodable locaitons
# needed to test the searching by geocode since
# if a board location geocode is nil it will show
# up in the searches
Location.blueprint(:geocodable) do
  user = User.make()
  street {"2164 Westview Drive"}
  locality {"Des Plaines"}
  region {"IL"}
  postal_code {"60018"}
  country {"USA"}
end

Location.blueprint(:geocodable2) do
  user = User.make()
  street {"233 W Micheltorena St"}
  locality {"Santa Barbara"}
  region {"CA"}
  postal_code {"93101"}
  country {"USA"}
end

Board.blueprint() do
  user = User.make()
  maker {Sham.board_maker}
  model {Sham.board_model}
  length {7}
  width {2}
  thickness {5}
  style {Style.make()}
  description {Sham.board_description}
  location {Location.make()}
  construction {Sham.board_construction}
  creator {user}
  updater {user}
end

# use this blueprint to make sure your 
# board is geocodable
Board.blueprint(:geocodable) do
  location {Location.make(:geocodable)}
end

Style.blueprint() do
  name {Sham.style_name}
end

Image.blueprint() do

end

UnavailableDate.blueprint() do
  user = User.make()
  board {Board.make()}
  date Sham.future_date
  creator {user}
  updater {user}
end

BoardSearch.blueprint() do
  # we need to save the location so we have
  # a valid geocode
  location = Location.make(:geocodable)
  location.save
  geocode {location.geocode}
  style {nil}
end