class Api::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  include Devise::Controllers::Helpers
  
  before_filter :ensure_params_exist, :only => [:create]
  
  def create
    #build_resource
    resource = User.find_for_database_authentication(:username=>params[:user_login][:username])
    
    return invalid_login_attempt unless resource
 
    if resource.valid_password?(params[:user_login][:password])
      sign_in("user", resource)
      render :json=> {:success=>true}.merge(resource.attributes)
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    sign_out(resource_name)
    warden.custom_failure!
    render :json=> {:success=>true, :message=>"Logged out"}, :status=>401
  end
 
  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end