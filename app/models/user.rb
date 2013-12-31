class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :admin, :time_zone, :allowed_user_ids, :allowing_user_ids
  attr_accessor :password
  
  before_save :prepare_password
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 3
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)
  
  has_many :uploads, :dependent => :destroy
  has_many :downloads, :dependent => :destroy

  has_many :shares, :dependent => :destroy
  has_many :shared_with, through: :shares, :source => :upload
  
  has_many :exchanges, foreign_key: "allowed_id", dependent: :destroy
  has_many :reverse_exchanges, foreign_key: "allowing_id", class_name: "Exchange", dependent: :destroy

  has_many :allowed_users, through: :exchanges, source: :allowing
  has_many :allowing_users, through: :reverse_exchanges, source: :allowed

  validates :slug, uniqueness: true, presence: true
  before_validation :generate_slug

  def to_param
    slug
  end
  
  def generate_slug
    self.slug ||= name.parameterize
  end

  def users_choices
    User.all - Array(self)
  end
  
  def allowed_users_with_admins
    allowed_users + User.admins
  end
  
  def allowed_recipients
    if admin? 
      recipients = User.all 
    else
      recipients = allowed_users
    end
    recipients - Array(self)
  end
  
  def is?(user)
    self == user
  end
  
  def is_not?(user)
    self != user
  end
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      User
    end
  end
  
  def self.authenticate(login, pass)
    user = find_by_name(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end
  
  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, token)
  end
  
  def admin?
    return true if admin
  end
  
  def can_download?(upload)
    true if (id == upload.user_id) || (upload.shared_with? self)
  end

  def can_manage?(upload)
    true if upload.user == self || self.admin?
  end
  
  def self.sharing_uploads_with(user)
    ( user.allowing_users - Array(user) + User.admins ).uniq
  end
  
  def allowed_uploads
    if admin?
      Upload
    else
      uploads
    end
  end
  
  def self.admins
    where(:admin => true)
  end
  
  def downloads
    Upload.shared_with(self)
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.token = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

end
