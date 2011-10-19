class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_subdomain, :check_my_subdomain
  before_filter :current_subdomain

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_subdomain
    Subdomain.find_by_name!(request.subdomain) if request.subdomain.present?
  end      

  def after_sign_in_path_for(resource_or_scope)
    if current_subdomain.nil? 
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      home_path = valid_user_url(token, :subdomain => subdomain_name)
      return home_path 
    else
      if current_user.subdomain != current_subdomain 
        sign_out(current_user)
        flash[:notice] = nil
        flash[:alert] = "Sorry, invalid user or password for subdomain"
      end
    end
    super
  end
  
end
