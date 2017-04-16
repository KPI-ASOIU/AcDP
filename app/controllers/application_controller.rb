class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t('util.access_denied')
    redirect_to root_path
  end

  # By default it should be done with 
  # comment_destroy_conditions. But Opinio does not 
  # support Rails 4, so this method replace that helper
	# def can_destroy_opinio?(comment)
	# 	comment.owner == current_user
	# end

  comment_destroy_conditions do |comment|
    comment.owner == current_user
  end

  # As current_user is inaccessible via models,
  # solve that problem with before_action :set_current_user
  # on all controllers you wish the corresponding models
  # to treat current_user
  def set_current_user
    User.current = current_user
  end

  def panel_activity
    @activities = PublicActivity::Activity.order('created_at DESC')
      .where("connected_to_users LIKE '% #{current_user.id} %'")

    if params[:type].present?
      @activities = @activities.select{ |a| a[:trackable_type] == params[:type] or 
        a.trackable[:commentable_type] == params[:type] if a.trackable.present? }
    end
    @activities = @activities[params[:summand].present? ? 0..(6+params[:summand].to_i) : 0..6]
    
    respond_to do |format|
      format.js
      format.html
    end
  end
end
