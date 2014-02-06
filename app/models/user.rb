class User < ActiveRecord::Base
  devise :database_authenticatable

  validates_presence_of   :login
  validates_uniqueness_of :login

  validates_length_of       :password, within: Devise.password_length, :if => :password_required?
  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
