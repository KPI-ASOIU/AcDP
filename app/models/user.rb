class User < ActiveRecord::Base
  devise :database_authenticatable

  has_attached_file :avatar,
    :styles => { :small => '48x48#', :medium => '64x64#', :large => '128x128#'},
    :path => ":rails_root/public/system/users/avatars/:id/:style/:filename",
    :url => "/system/users/avatars/:id/:style/:filename",
    :default_url => '/system/users/avatars/default/missing.png'

  validates_attachment :avatar,
    :content_type => { :content_type => %w(image/jpeg image/jpg image/png)},
    :size => { :in => 0..2.megabytes }

  validates_presence_of   :login
  validates_presence_of   :full_name
  validates_uniqueness_of :login

  validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?

  validates_length_of       :password, within: Devise.password_length, :if => :password_required?
  validates_presence_of     :password, :if => :password_required?
  validates_presence_of :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  scope :with_matched_field, ->(field, value) { where(User.arel_table[field].matches('%' + value + '%')) }
  scope :with_roles, ->(roles) { where('role & ? > 0', User.roles_to_int(roles))}

  def self.with_matched_field_and_role(field, value, roles)
    User.where('"users"."' + field + '" ILIKE \'%' + value + '%\' AND "users"."role" & ' +
                   User.roles_to_int(roles).to_s + ' > 0')
  end

  has_many :subscriptions

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  ROLES = %w[student worker teacher admin]

  def self.roles_to_int(roles)
    (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles=(roles)
    self.role = User.roles_to_int(roles)
  end

  def add_role(role)
    self.roles = roles + [role]
  end

  def remove_role(role)
    self.roles = roles - [role]
  end

  def has_role?(role)
    roles.include?(role.to_s)
  end

  def roles
    ROLES.reject do |r|
      ((role.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end
end
