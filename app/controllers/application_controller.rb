class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t('util.access_denied')
    redirect_to root_path
  end
end
