class User < ActiveRecord::Base
  include HasGravatar
  include HasFirstnameLastname
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  acts_as_tagger

  belongs_to :tenant
  has_one    :author
  has_many   :media
  has_many   :tenants
  has_many   :posts, through: :authors
  has_many   :localizations
  has_many   :locales

  validates_presence_of :email, :tenant, :firstname, :lastname

  scope :tenantUsers, -> (tenant_id) { where(tenant_id: tenant_id) }

  def referenced?
    [Media, Post, Locale, Localization, BulkJob].find do |resource|
      true if resource.where(user: self).count > 0
    end
  end

  def anonymous?
    self.id == nil
  end

  def is_admin?
    self.admin
  end

  def client_skips_authorization?
    # Yeah, replace this with something serious
    self.email == 'surgeon@careerbuilder.com'
  end

  def to_json(options={})
    options[:only] ||= %w(id email created_at updated_at tenant_id firstname lastname admin)
    options[:methods] ||= %w(fullname)
    super(options)
  end

  class << self
    def authenticate(username, password)
      user = User.find_by_email(username)
      user && user.valid_password?(password) ? user : nil
    end

    def anonymous
      User.new
    end
  end
end
