
def make_shop_search
  # we need to save the location so we have
  # a valid geocode
  location = SearchLocation.make()
  location.save
  ShopSearch.make(:location => location)

end