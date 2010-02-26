class Board < ActiveRecord::Base
  acts_as_commentable

  belongs_to :style
  belongs_to :location, :class_name => 'BoardLocation'
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :images, :as => :owner
  has_many :reservations
  has_many :reserved_dates, :through=>:reservations, :source=>:reserved_dates
  has_many :black_out_dates, :class_name=>'UnavailableDate', :as=> :parent

  validates_presence_of :name, :style, :location
  validates_numericality_of :daily_fee, :unless => :for_purchase?, :on => :create
  validates_numericality_of :purchase_price, :if => :for_purchase?, :on => :create
  validates_numericality_of :buy_back_price, :if => :for_purchase?, :on => :create

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
