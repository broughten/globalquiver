class Invoice < ActiveRecord::Base
  belongs_to :responsible_user , :class_name => "User"
  
end
