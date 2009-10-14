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
  board_length do
    the_array = (6..10).to_a
    the_array[Kernel.rand(the_array.length)]
  end
  board_width do
    the_array = (2..4).to_a
    the_array[Kernel.rand(the_array.length)]
  end
  board_thickness do
    the_array = (1..3).to_a
    the_array[Kernel.rand(the_array.length)]
  end
  board_description {Faker::Lorem.words(10)}
  board_construction {Faker::Lorem.words(1)}
  location_street {Faker::Address.street_address()}
  location_locality {Faker::Address.us_state()}
  location_postal_code {Faker::Address.zip_code()}
  style_name {Faker::Lorem.words(1)}
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
end
# End of user hierarchy blueprints

Location.blueprint() do
  user = User.make()
  street {Sham.location_street}
  locality {Sham.location_locality}
  region {"Region"}
  postal_code {Sham.location_postal_code}
  country {"USA"}
  creator {user}
  updater {user}
end

Board.blueprint() do
  user = User.make()
  maker {Sham.board_maker}
  model {Sham.board_model}
  length {Sham.board_length}
  width {Sham.board_width}
  thickness {Sham.board_thickness}
  style {Style.make()}
  description {Sham.board_description}
  location {Location.make()}
  construction {Sham.board_construction}
  creator {user}
  updater {user}
end

Style.blueprint() do
  name {Sham.style_name}
end