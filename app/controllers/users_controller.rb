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

  def set_user
    @user = User.find(params[:id])
  end

  def update_current
    @user = current_user
    if @user.update(user_params)
      redirect_to current_user_users_path, notice: t('users.notice.updated')

    else
      render action: 'edit_current'
    end
  end

  def avatar
    @user = current_user
    if @user.avatar.destroy
      @user.save
      redirect_to current_user_edit_users_path
    else
      redirect_to current_user_edit_users_path, :alert => t('activerecord.errors.models.avatar.delete')
    end
  end

  private
  def user_params
    params.require(:user)
       .permit(:password, :password_confirmation, :email, :full_name, :avatar, :position, :about_me)
       .delete_if {|k, v| k =~ /password/ && v.blank?}
  end
end
