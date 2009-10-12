When /^I create a new location$/ do
  Location.create!(:street => '604 Crazy Horse Cir',
                   :locality => 'Edwards',
                   :region => 'CO',
                   :postal_code => '81632',
                   :country => 'US')
end
