require 'paperclip'
class Image < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  #set up the Paperclip specific stuff
  # setting a style with the name of "original" will make sure that the actual image that
  # gets stored will not be too big. See http://railsforum.com/viewtopic.php?id=28064
  # for more details.
  has_attached_file :data, :styles => { :thumb => "100x100>",:original => "600x600" }        
  validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/png'], :message => "has to be in jpeg or png format"
  validates_attachment_size :data, :less_than => 2.megabytes
end
