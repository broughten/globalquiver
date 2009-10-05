class Shop < User

  # This will give us a common way to display someone's name
  # depending on what type of user they are.
  def display_name
    read_attribute(:name)
  end

  def is_rental_shop?
    true
  end

end