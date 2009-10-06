module LocationsHelper

  def already_has_location(locations)
    (!locations.nil? and locations.length > 0) ? 'display:none' : ''
  end

end
