class GenericBoard < Board

  validates_presence_of :lower_length, :upper_length

  validates_numericality_of :lower_length, :upper_length
  validate :upper_length_is_greater_than_lower_length

  public

  def lower_length_feet
    self.lower_length / 12
  end

  def lower_length_feet=(feet)
    logger.debug("HI JC wtf is lower legth set? : #{@lower_length_set}")
    if (self.lower_length.blank? || !@lower_length_set)
      self.lower_length = feet.to_f * 12
      @lower_length_set = true
      logger.debug("HI JC!! just set lower length (in feet method) to #{self.lower_length}")
    else
      self.lower_length += feet.to_f * 12
      @lower_length_set = false
      logger.debug("HI JC!! just set lower length (in feet additive method) to #{self.lower_length}")

    end
  end

  def lower_length_inches
    self.lower_length - ((self.lower_length / 12) * 12)
  end

  def lower_length_inches=(inches)
    logger.debug("HI JC wtf is lower legth set? : #{@lower_length_set}")
    if (self.lower_length.blank? || !@lower_length_set)
      self.lower_length = inches.to_f
      @lower_length_set = true
      logger.debug("HI JC!! just set lower length (in inches method) to #{self.lower_length}")

    else
      self.lower_length += inches.to_f
      @lower_length_set = false
      logger.debug("HI JC!! just set lower length (in inches additive method) to #{self.lower_length}")

    end
  end


  def upper_length_feet
    self.upper_length / 12
  end

  def upper_length_feet=(feet)
    logger.debug("HI JC wtf is upper legth set? : #{@upper_length_set}")
    if (self.upper_length.blank? || !@upper_length_set)
      self.upper_length = feet.to_f * 12
      @upper_length_set = true
      logger.debug("HI JC!! just set upper length (in feet method) to #{self.upper_length}")

    else
      self.upper_length += feet.to_f * 12
      @upper_length_set = false
      logger.debug("HI JC!! just set upper length (in feet additive method) to #{self.upper_length}")

    end
  end

  def upper_length_inches
    self.upper_length - ((self.upper_length / 12) * 12)
  end

  def upper_length_inches=(inches)
    logger.debug("HI JC wtf is upper legth set? : #{@upper_length_set}")

    if (self.upper_length.blank? || !@upper_length_set)
      self.upper_length = inches.to_f
      @upper_length_set = true
      logger.debug("HI JC!! just set upper length (in inches method) to #{self.upper_length}")

    else
      self.upper_length += inches.to_f
      @upper_length_set = false
      logger.debug("HI JC!! just set upper length (in inches additive method) to #{self.upper_length}")

    end
  end

  def upper_length_is_greater_than_lower_length
    errors.add_to_base("upper length must be greater than lower length") unless upper_length.blank? || lower_length.blank? || upper_length > lower_length
  end

  private

  @upper_length_set = false
  @lower_length_set = false

end
