class User < ActiveRecord::Base
  devise :database_authenticatable

  validates_presence_of   :login, :password
  validates_uniqueness_of :login
  validates_length_of     :password, within: Devise.password_length
end
