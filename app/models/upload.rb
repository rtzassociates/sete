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
  
  def filename
    asset.to_s.split("/").last
  end
  
  def default_name
    self.name ||= File.basename(asset.filename, '.*').titleize if asset
  end
  
  def self.shared_with(user)
    if user.admin?
      scoped
    else
      joins(:shares).where("shares.user_id = ?", user.id)
    end  
  end
  
  def self.shared_with_count(user)
    if user.admin?
      user.uploads.count
    else
      Upload.shared_with(user).count
    end
  end
  
  def shared_with?(user)
    shared_with_ids.include?(user.id)
  end

  def unshare_with(user)
    shares.find_by_user_id(user.id).destroy
  end

  def self.uploaded_between(start_date, end_date)

    start_date = Time.zone.now.to_s if start_date.blank?
    start_date = Date.parse(start_date).beginning_of_day

    end_date   = Time.zone.now.to_s if end_date.blank?
    end_date   = Date.parse(end_date).end_of_day
    
    where(created_at: start_date..end_date)

  end
  
end
