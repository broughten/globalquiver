
def make_board_search
  # we need to save the location so we have
  # a valid geocode
  location = SearchLocation.make()
  location.save
  BoardSearch.make(:location => location)

end