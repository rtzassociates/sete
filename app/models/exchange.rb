class Exchange < ActiveRecord::Base
  attr_accessible :allowed_id
  attr_accessible :allowing_id
  
  belongs_to :allowed, class_name: "User"
  belongs_to :allowing, class_name: "User"
end
