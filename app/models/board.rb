class Board < ActiveRecord::Base

  belongs_to :style
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'

  def style_name
    style.name if style
  end

  def style_name=(name)
    self.style = Style.find_or_create_by_name(name) unless name.blank?
  end

  fractions = {'0.0625' => '1/16',
               '0.125' => '1/8',
               '0.1875' => '3/16',
               '0.25' => '1/4',
               '0.3125' => '5/16',
               '0.375' => '3/8',
               '0.4375' => '7/16',
               '0.5' => '1/2',
               '0.5625' => '9/16',
               '0.625' => '5/8',
               '0.6875' => '11/16',
               '0.75' => '3/4',
               '0.8125' => '13/16',
               '0.875' => '7/8',
               '0.9375' => '15/16'
               }

  def length_feet
    self.length div 12
  end

  def length_feet=(feet)
    if (self.length.nil?)
      self.length = feet.to_f * 12
    else
      self.length += feet.to_f * 12
    end
  end

  def length_inches
    self.length - ((self.length div 12) * 12)
  end

  def length_inches=(inches)
    if (self.length.nil?)
      self.length = inches.to_f
    else
      self.length += inches.to_f
    end
  end

  def width_inches
    self.width.floor
  end

  def width_inches=(inches)
    if (self.width.nil?)
      self.width = inches.to_f
    else
      self.width += inches.to_f
    end
  end

  def width_fraction
    if (!self.width.nil?)
      fraction_value = fractions((self.width - self.width.floor).to_s)
      if (fraction_value == nil)
        return '0'
      else
        return fraction_value
      end      
    end
  end

  def width_fraction=(fraction)
    if (self.width.nil?)
      self.width = fraction.to_f
    else
      self.width += fraction.to_f
    end
  end

  def thickness_inches
    self.thickness.floor
  end

  def thickness_inches=(inches)
    if (self.thickness.nil?)
      self.thickness = inches.to_f
    else
      self.thickness += inches.to_f
    end
  end

  def thickness_fraction
    if (!self.thickness.nil?)
      fraction_value = fractions((self.thickness - self.thickness.floor).to_s)
      if (fraction_value == nil)
        return '0'
      else
        return fraction_value
      end
    end
  end

  def thickness_fraction=(fraction)
    if (self.thickness.nil?)
      self.thickness = fraction.to_f
    else
      self.thickness += fraction.to_f
    end

  end

end
