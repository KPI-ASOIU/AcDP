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
    if @user.update(user_params.except(:role))
      redirect_to [:admin, @user], notice: t('users.notice.updated')
    else
      render action: 'edit'
    end
  end

  private
  def user_params
    params.require(:user)
       .permit(:password, :password_confirmation, :email, :full_name, :avatar)
       .delete_if {|k, v| k =~ /password/ && v.blank?}
  end
end
