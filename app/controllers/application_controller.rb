class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_subdomain, :check_my_subdomain
  before_filter :current_subdomain, :find_tennant

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_subdomain
    Subdomain.find_by_name!(request.subdomain) if request.subdomain.present?
  end

  def find_tennant
    Multitenant.current_tenant = current_subdomain
  end

  def after_sign_in_path_for(resource_or_scope)
    if current_subdomain.nil?
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      return valid_user_url(token, :subdomain => current_user.subdomain.name)
    else
      if current_user.subdomain != current_subdomain
        sign_out(current_user)
        flash[:notice] = nil
        flash[:alert] = "Sorry, invalid user or password for subdomain"
      end
    end
    if current_user.admin?
      return dashboard_index_path
    else
      return :root
    end
    super
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Please login to the site"
    if request.xhr?
      render 'users/redirect'
    else
      redirect_to root_url
    end
  end

end
