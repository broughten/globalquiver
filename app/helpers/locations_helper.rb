module LocationsHelper

  def alreadyHasLocation(locations)
    (!locations.nil? and locations.length > 0) ? 'display:none' : ''
  end

end
