class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable

  validates_presence_of   :login
  validates_uniqueness_of :login

  validates_length_of       :password, within: Devise.password_length, :if => :password_required?
  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
end
