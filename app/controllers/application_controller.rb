class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::PERMIT_COLUMNS)
    devise_parameter_sanitizer.permit(:account_update, keys: User::PERMIT_COLUMNS)
  end

  def authenticate_admin_user!
    unless admin_user_signed_in?
      redirect_to new_admin_user_session_path
    end
  end  
end
