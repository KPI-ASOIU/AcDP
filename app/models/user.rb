class User < ActiveRecord::Base
  devise :database_authenticatable

  validates_presence_of   :login
  validates_uniqueness_of :login
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true

  def update_by_admin user_params
    if user_params[:password].blank?
      user_params.delete("password")
      user_params.delete("password_confirmation")
    elsif user_params[:password] != user_params[:password_confirmation]
    	self.errors.messages[:password] = ["Check your passwords. They are not equal"]
    	return false
    end
    self.update(user_params)
  end
end
