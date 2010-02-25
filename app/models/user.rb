require 'digest/sha1'

# This class serves as an abstratct base class for Surfer and Shop
class User < ActiveRecord::Base
  has_many  :boards, :foreign_key =>"creator_id"
  has_many  :reservations, :foreign_key =>"creator_id"
  has_many  :board_locations, :foreign_key =>"creator_id"
  has_many  :locations, :foreign_key =>"creator_id"
  has_one   :image, :as => :owner, :dependent => :destroy
  has_many  :reservations_for_owned_boards, :through=>:boards, :source=>:reservations

  belongs_to :location
  belongs_to :user_location, :foreign_key => 'location_id'
  accepts_nested_attributes_for :user_location
 
  has_and_belongs_to_many :pickup_times


  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_format_of       :email, :with => /.*@.*/, :message => 'email is invalid'
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  # This is needed to make sure that the validates_confirmation_of :password is run.
  # Without this, if :password_confirmation is nil the confirmation check
  # will not run. 
  validates_presence_of     :password_confirmation,        :if => :password_required?
  validates_uniqueness_of   :email, :case_sensitive => false, :on => :create

  # since we are evaluating a db column we need to set the :accept option
  validates_acceptance_of :terms_of_service, :accept => true

  before_save :encrypt_password

  named_scope :limited_to, lambda{|count| {:limit => count} }
  named_scope :latest, :order => 'users.created_at DESC'
  named_scope :board_owners_needing_reminder_emails,
    lambda{|time| {:joins => :reservations_for_owned_boards, :conditions => ['reservations.created_at >= ? or reservations.deleted_at >= ?', time, time]} }

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :terms_of_service, :image_attributes, :description, :url, :friendly, :pickup_time_ids, :user_location_attributes, :location_id
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
  
  def self.send_reservation_update_for_owned_boards(time)
    User.board_owners_needing_reminder_emails(time).find_each do |user|
      UserMailer.deliver_board_owner_reservation_update(user, 
        user.reservations_for_owned_boards.created_since(time),
        user.reservations_for_owned_boards.deleted_since(time))
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

  def is_rental_shop?
    false
  end

  def display_name
    "User" # placeholder...will be redefined in sub classes.
  end
  
  def full_name
    "User" # placeholder...will be redefined in sub classes.
  end

  def create_password_reset_code
   @password_reset = true
   self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
   self.save(false)
  end

  def password_recently_reset?
   @password_reset
  end

  def delete_password_reset_code
   self.password_reset_code = nil
   self.save(false)
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

    def updating_email?
      # validate_uniqueness_of email unless specifically set to false
      if updating_email == false
       return false
      else
       return true
      end
    end
    
    
end
