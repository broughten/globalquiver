require 'paperclip'
class Image < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  #set up the Paperclip specific stuff
  has_attached_file :data, :styles => { :thumb => "100x100>" }        
  #validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/png'], :message => "has to be in jpeg or png format"
end
