class Upload < ActiveRecord::Base

  attr_accessible :asset, :name, :user_id, :shared_with_ids
  
  belongs_to :user
  before_create :default_name
  mount_uploader :asset, AssetUploader
  validates_presence_of :asset
  
  has_many :shares, :dependent => :destroy
  has_many :shared_with, through: :shares, :source => :user
  has_many :downloads
  
  default_scope :order => 'id DESC'

  before_save :add_allowed_users_if_missing

  def add_allowed_users_if_missing
    shared_with_ids.each do |user_id|
      shared_user = User.find(user_id)
      unless user.allowed_users.include? shared_user
        user.allowed_users << shared_user
        user.save
      end
    end
  end
  
  def filename
    asset.to_s.split("/").last
  end
  
  def default_name
    self.name ||= File.basename(asset.filename, '.*').titleize if asset
  end
  
  def self.shared_with(user)
    joins(:shares).where("shares.user_id = ?", user.id) 
  end
  
  def shared_with?(user)
    shared_with_ids.include?(user.id)
  end

  def unshare_with(user)
    shares.find_by_user_id(user.id).destroy
  end

  def self.uploaded_between(start_date, end_date)

    start_date = '1970-01-01' if start_date.blank?
    start_date = Date.parse(start_date).beginning_of_day

    end_date   = Time.zone.now.to_s if end_date.blank?
    end_date   = Date.parse(end_date).end_of_day
    
    where(created_at: start_date..end_date)

  end
  
end
