class SpecificBoard < Board

  validates_presence_of :maker, :length
 
  def length_feet
    self.length / 12
  end

  def length_feet=(feet)
    if (self.length.blank? || self.length_feet >= 1)
      self.length = feet.to_f * 12
    else
      self.length += feet.to_f * 12
    end
  end

  def length_inches
    self.length - ((self.length / 12) * 12)
  end

  def length_inches=(inches)
    if (self.length.blank? || self.length_inches >= 1)
      self.length = inches.to_f
    else
      self.length += inches.to_f
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
    if (self.width.blank? || self.width >= 1)
      self.width = inches.to_f
    else
      self.width += inches.to_f
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
    if (self.width.blank? || self.width >= 1)
      self.width = fraction.to_f
    else
      self.width += fraction.to_f
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
    if (self.thickness.blank? || self.thickness >= 1)
      self.thickness = inches.to_f
    else
      self.thickness += inches.to_f
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
    if (self.thickness.blank? || self.thickness >= 1)
      self.thickness = fraction.to_f
    else
      self.thickness += fraction.to_f
    end

  end
  
end
