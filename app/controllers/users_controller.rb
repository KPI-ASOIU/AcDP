class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:dashboard]

  def show
  end

  def dashboard
    @user = current_user
    @reminder_tasks = Task.order('end_date DESC').connected_to_me.with_end_date(Time.now, Time.now + 3.days)
      .with_status('Active')
    @reminder_events = Event.order('date DESC').connected_to_me.with_date(Time.now, Time.now + 3.days)
    @activities = PublicActivity::Activity.order('created_at DESC')
      .where("connected_to_users LIKE '% #{current_user.id} %'")[0..6]
  end

  def edit_current
    @user = current_user
  end

  def set_user
    @user = User.find_by_id(params[:id]) or not_found
  end

  def update_current
    @user = current_user
    if @user.update(user_params)
      redirect_to dashboard_path, notice: t('users.notice.updated')

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
