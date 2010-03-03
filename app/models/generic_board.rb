class GenericBoard < Board

  validates_presence_of :lower_length, :upper_length

  validates_numericality_of :lower_length, :upper_length
  validate :upper_length_is_greater_than_lower_length
 
  def lower_length_feet
    self.lower_length / 12
  end

  def lower_length_feet=(feet)
    if (self.lower_length.blank? || self.lower_length >= 12)
      self.lower_length = feet.to_f * 12
    else
      self.lower_length += feet.to_f * 12
    end
  end

  def lower_length_inches
    self.lower_length - ((self.lower_length / 12) * 12)
  end

  def lower_length_inches=(inches)
    if (self.lower_length.blank? || self.lower_length_inches >= 1)
      self.lower_length = inches.to_f
    else
      self.lower_length += inches.to_f
    end
  end


  def upper_length_feet
    self.upper_length / 12
  end

  def upper_length_feet=(feet)
    if (self.upper_length.blank? || self.upper_length >= 12)
      self.upper_length = feet.to_f * 12
    else
      self.upper_length += feet.to_f * 12
    end
  end

  def upper_length_inches
    self.upper_length - ((self.upper_length / 12) * 12)
  end

  def upper_length_inches=(inches)
    if (self.upper_length.blank? || self.upper_length_inches >= 1)
      self.upper_length = inches.to_f
    else
      self.upper_length += inches.to_f
    end
  end

  def upper_length_is_greater_than_lower_length
    errors.add_to_base("upper length must be greater than lower length") unless upper_length.blank? || lower_length.blank? || upper_length > lower_length
  end

end
