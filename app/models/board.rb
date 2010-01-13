class Board < ActiveRecord::Base

  belongs_to :style
  belongs_to :location, :class_name => 'BoardLocation'
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :images, :as => :owner
  has_many :reservations
  has_many :reserved_dates, :through=>:reservations, :source=>:reserved_dates
  has_many :black_out_dates, :class_name=>'UnavailableDate', :as=> :parent

  validates_presence_of :name, :maker, :style, :length, :location
  validates_numericality_of :daily_fee, :on => :create

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :black_out_dates, :allow_destroy => true
  named_scope :active, :conditions=>{:inactive=>false}
  
  MAX_IMAGES = 4
  
  def style_name
    style.name if style
  end

  def style_name=(name)
    self.style = Style.find_or_create_by_name(name) unless name.blank?
  end

  
  FRACTIONS = {'0.0' => '0',
                '0.0625' => '1/16',
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
    self.length / 12
  end

  def length_feet=(feet)
    if (self.length.nil?)
      self.length = feet.to_f * 12
    else
      self.length += feet.to_f * 12
    end
  end

  def length_inches
    self.length - ((self.length / 12) * 12)
  end

  def length_inches=(inches)
    if (self.length.nil?)
      self.length = inches.to_f
    else
      self.length += inches.to_f
    end
  end

  def width_inches
    if (self.width.nil?)
      return nil
    else
      return self.width.floor
    end
    
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
      fraction_value = FRACTIONS[(self.width - self.width.floor).to_s]
      if (fraction_value.nil?)
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
    if (self.thickness.nil?)
      return nil
    else
      return self.thickness.floor
    end

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
      fraction_value = FRACTIONS[(self.thickness - self.thickness.floor).to_s]
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
  
  def has_location?
    self.location != nil
  end
  
  def user_is_owner(user)
    self.creator == user or self.creator.nil?
  end
  
  def user_is_renter(user)
    self.reservations.active.for_user(user).count > 0
  end
  
  def active?
    !inactive
  end
  
  def deactivate
    self.inactive = true
  end
  
  def activate
    self.inactive = false
  end
  
  def status
    if self.active?
      "Active"
    else
      "Inactive"
    end
  end
  
  def has_future_reservations
    self.reservations.with_dates_after(Time.now).length > 0
  end
end
