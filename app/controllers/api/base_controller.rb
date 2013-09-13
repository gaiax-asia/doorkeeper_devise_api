class Api::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  respond_to :json
  
  protect_from_forgery with: :null_session
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password) }
    
    devise_parameter_sanitizer.for(:sign_up) do
      |u| u.permit(:username, :email, :password, :password_confirmation)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password)
    end
  end
end
