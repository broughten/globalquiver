module LocationsHelper

  def alreadyHasLocation(locations)
    (locations.nil? or locations.length > 0) ? 'display:none' : ''
  end

end
