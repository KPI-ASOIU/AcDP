class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
  end
  def set_user
    if params[:id] == "current"
      redirect_to(action: params[:action], id: current_user.id)
      return
    end
    @user = User.find(params[:id])
  end
end
