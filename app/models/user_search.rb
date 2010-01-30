class UserSearch < ActiveRecord::Base
  belongs_to :location, :class_name => 'SearchLocation'
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'

  set_inheritance_column 'search_type'
  
  def execute
    type = nil
    if self.is_a?(SurferSearch)
      type = 'surfer'
    elsif self.is_a?(ShopSearch)
      type = 'shop'
    end
    users = Array.new
    if self.location
      UserLocation.find(:all, :within => self.location.search_radius, :origin => self.location.to_s).each do |user_location|
        users = user_location.send(type.pluralize).first_name_like(self.terms) |
                 user_location.send(type.pluralize).last_name_like(self.terms) |
                 user_location.send(type.pluralize).name_like(self.terms) |
                 user_location.send(type.pluralize).email_like(self.terms)
      end
    elsif !self.terms.blank?
      users = type.capitalize.constantize.first_name_like(self.terms) |
              type.capitalize.constantize.last_name_like(self.terms) |
              type.capitalize.constantize.name_like(self.terms) |
              type.capitalize.constantize.email_like(self.terms)
    end
    return users.uniq
  end
end
