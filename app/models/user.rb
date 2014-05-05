class User < ActiveRecord::Base
  devise :database_authenticatable
  has_one :student_info
  has_one :group, through: :student_info
  has_and_belongs_to_many :contacts,
      join_table: "contacts",
      class_name: "User",
      foreign_key: "user_id",
      association_foreign_key: "contact_user_id",
      uniq: true

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

  has_many :subscriptions
  has_many :documents, through: :user_has_accesses
  has_many :user_has_accesses

  has_and_belongs_to_many :executing_tasks, class_name: "Task", join_table: :executing_tasks_executors, foreign_key: :executor_id
  has_many :leading_tasks, class_name: "Task"

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  ROLES = %w[student worker teacher admin]

  def self.get_roles_ids
    ROLES
  end

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

  def unread_messages_count_sum
    self.subscriptions.sum("unread_messages_count")
  end
end
