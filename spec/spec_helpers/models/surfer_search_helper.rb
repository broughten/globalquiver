
def make_surfer_search
  # we need to save the location so we have
  # a valid geocode
  location = SearchLocation.make()
  location.save
  SurferSearch.make(:location => location)

end