class Share < ActiveRecord::Base
  attr_accessible :user_id, :upload_id
  
  belongs_to :upload
  belongs_to :user
  
end
