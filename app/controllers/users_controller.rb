class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
  end

  def show_current
    @user = current_user
    @activities = PublicActivity::Activity.all.order('created_at DESC')
      .select { |a| a[:parameters][:connected_to_users].include?(current_user.id) }

    if !params[:type].nil?
      @activities = @activities.select{ |a| a[:trackable_type] == params[:type] || 
        a.trackable[:commentable_type] == params[:type] if !a.trackable.nil? }
    end
    @activities = @activities[!params[:summand].nil? ? 0..(6+params[:summand].to_i) : 0..6]
    
    respond_to do |format|
      format.js
      format.html
    end
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
