class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
  end

  def show_current
    @user = current_user
  end

  def edit_current
    @user = current_user
  end

  def update_current
    @user = current_user
    if @user.update(user_params)
      redirect_to current_user_users_path, notice: t('users.notice.updated')
    else
      render action: 'edit_current'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user)
    .permit(:password, :password_confirmation, :email, :full_name)
    .delete_if {|k, v| k =~ /password/ && v.blank?}
  end
end
