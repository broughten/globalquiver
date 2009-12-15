class Surfer < User

  validates_presence_of :first_name, :message => "first name can't be blank."

  attr_accessible :first_name, :last_name

  # This will give us a common way to display someone's name
  # depending on what type of user they are.
  def display_name
    read_attribute(:first_name)
  end
  
  def full_name
    "#{read_attribute(:first_name)} #{read_attribute(:last_name)}"
  end

end