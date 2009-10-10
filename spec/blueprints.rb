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
end

Surfer.blueprint() do
  first_name
  last_name
  email
  password {"good_password"}
  password_confirmation {password}
  terms_of_service {true}
end

Shop.blueprint() do
  name {Sham.shop_name}
  email
  password {"good_password"}
  password_confirmation {password}
  terms_of_service {true}
end