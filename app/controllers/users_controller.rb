class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
  end

  def show_current
    @user = current_user
  end
  def set_user
    @user = User.find(params[:id])
  end
end
