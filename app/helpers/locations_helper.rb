module LocationsHelper

  def alreadyHasLocation(locations)
    locations.length > 0 ? 'display:none' : ''
  end
end
