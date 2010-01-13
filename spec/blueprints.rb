#Should be in every blueprints file.
require 'machinist/active_record'#http://github.com/notahat/machinist/
require 'sham' #see machinist
require 'faker' #http://faker.rubyforge.org/


#Set up the shams
# The ones without a block will look for sham definitions of the same name
Sham.define do
  #email { Faker::Internet.email }
  first_name  { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  name  { Faker::Lorem.words(1) }
  group_name {Faker::Lorem.words(2)}
  shop_name {Faker::Company.name}
  board_name {Faker::Company.name}
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
Sham.email do
  number = (1..100).to_a.rand
  "user#{number}@test.com"
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
  locality {Sham.location_city}
  region {Sham.location_state}
  country {"USA"}
  creator {User.make()}
  updater {creator}
end

BoardLocation.blueprint() do
  street {Sham.location_street}
  postal_code {Sham.location_postal_code}
end

UserLocation.blueprint() do
  street {Sham.location_street}
  postal_code {Sham.location_postal_code}
end

SearchLocation.blueprint() do
  search_radius {100}
end

#Use the next two locations to get geocodable locaitons
# needed to test the searching by geocode since
# if a board location geocode is nil it will show
# up in the searches
Location.blueprint(:des_plaines_il) do
  locality {"Des Plaines"}
  region {"IL"}
  country {"USA"}
end

Location.blueprint(:santa_barbara_ca) do
  locality {"Santa Barbara"}
  region {"CA"}
  country {"USA"}
end

# The information from the above named blueprints needs to 
# be duplicated as per:
# http://groups.google.com:80/group/machinist-users/browse_thread/thread/e4e393701903b778
BoardLocation.blueprint(:des_plaines_il) do
  street {"2164 Westview Drive"}
  postal_code {"60018"}
  # duped stuff from above
  locality {"Des Plaines"}
  region {"IL"}
  country {"USA"}
end

BoardLocation.blueprint(:santa_barbara_ca) do
  street {"233 W Micheltorena St"}
  postal_code {"93101"}
  # duped stuff from above
  locality {"Santa Barbara"}
  region {"CA"}
  country {"USA"}
end

SearchLocation.blueprint(:des_plaines_il) do
  search_radius {100}
  # duped stuff from above
  locality {"Des Plaines"}
  region {"IL"}
  country {"USA"}
end

SearchLocation.blueprint(:santa_barbara_ca) do
  search_radius {100}
  # duped stuff from above
  locality {"Santa Barbara"}
  region {"CA"}
  country {"USA"}
end

Board.blueprint() do
  name {Sham.board_name}
  maker {Sham.board_maker}
  model {Sham.board_model}
  length {7}
  width {2}
  thickness {5}
  style {Style.make()}
  daily_fee {35}
  description {Sham.board_description}
  location {BoardLocation.make()}
  construction {Sham.board_construction}
  creator {User.make()}
  updater {creator}
end

# use this blueprint to make sure your 
# board is geocodable
Board.blueprint(:geocodable) do
  location {BoardLocation.make(:geocodable)}
end

Style.blueprint() do
  name {Sham.style_name}
end

Image.blueprint() do

end

UnavailableDate.blueprint() do
  date Sham.future_date
  creator {User.make()}
  updater {creator}
end

UnavailableDate.blueprint(:for_board) do
  parent {Board.make}
end

UnavailableDate.blueprint(:for_reservation) do
  parent {Reservation.make}
end

Reservation.blueprint(:deleted) do
  deleted_at {Time.now.utc}
end

BoardSearch.blueprint() do
  location {SearchLocation.make}
  style {nil}
end

PickupTime.blueprint() do
  name {Sham.name}
end

Reservation.blueprint() do
  board {Board.make()}
  creator {User.make()}
  updater {creator}
  reserved_dates {[UnavailableDate.make()]}
end