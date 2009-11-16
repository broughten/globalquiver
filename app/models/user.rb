require 'digest/sha1'

# This class serves as an abstratct base class for Surfer and Shop
class User < ActiveRecord::Base
  has_many  :owned_boards, :class_name => 'Board', :foreign_key =>"creator_id"
  has_many  :unavailable_dates
  has_many  :locations, :foreign_key =>"creator_id"
  has_one   :image, :as => :owner, :dependent => :destroy


  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_format_of       :email, :with => /.*@.*/
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  # This is needed to make sure that the validates_confirmation_of :password is run.
  # Without this, if :password_confirmation is nil the confirmation check
  # will not run. 
  validates_presence_of     :password_confirmation,        :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false

  # since we are evaluating a db column we need to set the :accept option
  validates_acceptance_of :terms_of_service, :accept => true

  before_save :encrypt_password

  named_scope :limited_to, lambda{|count| {:limit => count} }
  named_scope :latest, :order => 'users.created_at DESC'

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :terms_of_service, :image_attributes
  # allows for the image assocation to be created by auto assignment but you still have to 
  # add image_attributes to attr_accessible above.
  accepts_nested_attributes_for :image

  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  def self.has_boards_with_new_reservation_dates(time)
    users = Array.new
    User.all.each do |user|
      users << user if user.owned_boards.with_new_reserved_dates(time).length > 0
    end
    return users
  end
  
  def self.send_reservation_status_change_update
    time = 1.day.ago
    users = has_boards_with_new_reservation_dates(time)
    users.each do |user|
      new_board_reservation_dates = Hash.new
      boards_with_new_reservations = user.owned_boards.with_new_reserved_dates(time)
      boards_with_new_reservations.each do |board|
        new_reservation_dates = board.reserved_dates.recently_created(time)
        new_board_reservation_dates[board] = new_reservation_dates
      end
      UserMailer.deliver_board_owner_board_reservation_change_notification(user, new_board_reservation_dates, {})
    end
    
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def is_rental_shop?
    false
  end

  def display_name
    "" # placeholder...will be redefined in sub classes.
  end
  
  def full_name
    "" # placeholder...will be redefined in sub classes.
  end
  
  

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end
