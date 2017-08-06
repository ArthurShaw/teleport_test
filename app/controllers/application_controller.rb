class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    user_attributes = %i[
      email password password_confirmation
      login first_name last_name
    ]
    devise_parameter_sanitizer.permit(
      :sign_up, keys: user_attributes
    )
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
    devise_parameter_sanitizer.permit(
      :account_update, keys: %i[first_name last_name]
    )
  end
end
