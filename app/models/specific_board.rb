class SpecificBoard < Board

  validates_presence_of :maker, :length
 
  def length_feet
    self.length / 12
  end

  def length_feet=(feet)
    if (self.length.blank? || !@length_set)
      self.length = feet.to_f * 12
      @length_set = true
    else
      self.length += feet.to_f * 12
      @length_set = false
    end
  end

  def length_inches
    self.length - ((self.length / 12) * 12)
  end

  def length_inches=(inches)
    if (self.length.blank? || !@length_set)
      self.length = inches.to_f
      @length_set = true
    else
      self.length += inches.to_f
      @length_set = false
    end
  end

  def width_inches
    if (self.width.blank?)
      return nil
    else
      return self.width.floor
    end
    
  end

  def width_inches=(inches)
    if (self.width.blank? || !@width_set)
      self.width = inches.to_f
      @width_set = true
    else
      self.width += inches.to_f
      @width_set = false
    end
  end

  def width_fraction
    if (!self.width.blank?)
      fraction_value = (self.width - self.width.floor).to_s
      if (fraction_value.nil?)
        return '0.0'
      else
        return fraction_value
      end      
    end
  end

  def width_fraction=(fraction)
    if (self.width.blank? || !@width_set)
      self.width = fraction.to_f
      @width_set = true
    else
      self.width += fraction.to_f
      @width_set = false
    end
  end

  def thickness_inches
    if (self.thickness.blank?)
      return nil
    else
      return self.thickness.floor
    end

  end

  def thickness_inches=(inches)
    if (self.thickness.blank? || !@thickness_set)
      self.thickness = inches.to_f
      @thickness_set = true
    else
      self.thickness += inches.to_f
      @thickness_set = false
    end
  end

  def thickness_fraction
    if (!self.thickness.blank?)
      fraction_value = (self.thickness - self.thickness.floor).to_s
      if (fraction_value == nil)
        return '0.0'
      else
        return fraction_value
      end
    end
  end

  def thickness_fraction=(fraction)
    if (self.thickness.blank? || !@thickness_set)
      self.thickness = fraction.to_f
      @thickness_set = true
    else
      self.thickness += fraction.to_f
      @thickness_set = false
    end

  end

  private

  @length_set = false
  @width_set = false
  @thickness_set = false

end
