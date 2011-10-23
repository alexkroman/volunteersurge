class SitesController < ApplicationController
  load_and_authorize_resource
  
  before_filter :check_subdomain_exists?
  
  def index
    @site = Site.find_by_name(current_subdomain.name) || not_found      
  end
  
  protected
  
  def check_subdomain_exists?
    not_found unless current_subdomain
  end
  
end
