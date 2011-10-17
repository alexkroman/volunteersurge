class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  helper_method :current_subdomain, :check_my_subdomain
  before_filter :current_subdomain
  before_filter :set_mailer_url_options


  def current_subdomain
      if request.subdomains.first.present? && request.subdomains.first != "www"
        current_subdomain = Subdomain.find_by_name(request.subdomains.first)
      else 
        current_subdomain = nil
      end
      return current_subdomain
  end      
  
  def check_my_subdomain(subdomain)
    if subdomain != current_subdomain.name
      redirect_to "/opps" , :alert => "Sorry, resource is not part of your subdomain"
    end
  end


  def after_sign_in_path_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    subdomain_name = current_user.subdomain.name
    if current_subdomain.nil? 
      # logout of root domain and login by token to subdomain
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      home_path = valid_user_url(token, :subdomain => subdomain_name)
      return home_path 
    else
      if subdomain_name != current_subdomain.name 
        # user not part of current_subdomain
        sign_out(current_user)
        flash[:notice] = nil
        flash[:alert] = "Sorry, invalid user or password for subdomain"
      end
    end
    super
  end
  
end
