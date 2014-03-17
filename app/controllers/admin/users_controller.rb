class Admin::UsersController < ApplicationController
  authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :avatar]
  helper UsersHelper

  # GET /admin/users
  def index
    @roles = [{ :name => t('roles.plural.students'), :id => 'student' },
              { :name => t('roles.plural.workers'), :id => 'worker' } ,
              { :name => t('roles.plural.teachers'), :id => 'teacher' },
              { :name => t('roles.plural.admins'), :id => 'admin' }]

    users = if !params[:q].nil?
              params[:search_by] = 'login' unless ['login', 'email', 'full_name'].include?(params[:search_by])
              params[:role_ids] ||= []
              User.with_matched_field(params[:search_by], params[:q]).with_roles(params[:role_ids])
            else
              params[:role_ids] = ['student', 'worker', 'teacher', 'admin']
              User.all
            end

    params[:search_by] ||= 'login'
    @users = users.page(params[:page])
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    @user.roles = user_params[:role] || []

    if @user.save
      redirect_to [:admin, @user], notice: t('users.notice.created')
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    @user.roles = user_params[:role] || []

    if @user.update(user_params.except(:role))
      redirect_to [:admin, @user], notice: t('users.notice.updated')
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.avatar.destroy
    @user.destroy
    redirect_to admin_users_url
  end

  def avatar
    if @user.avatar.destroy
      @user.save
      redirect_to edit_admin_user_path(@user)
    else
      redirect_to edit_admin_user_path(@user), :alert => t('activerecord.errors.models.avatar.delete')
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user)
       .permit(:login, :password, :password_confirmation, { :role => [] }, :email, :full_name, :avatar, :position, :about_me)
       .delete_if {|k, v| k =~ /password/ && v.blank?}
  end
end
