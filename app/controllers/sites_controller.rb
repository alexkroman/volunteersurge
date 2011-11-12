class SitesController < ApplicationController
  load_and_authorize_resource
  
  before_filter :check_subdomain_exists?
  
  def index
    @site = Site.find(current_subdomain)
  end

  def faq
  end
  
  def about
  end
  
  def update
    respond_to do |format|
      if current_subdomain.update_attributes(params[:site])
        format.html { redirect_to sites_path, :notice => 'Site was successfully updated.' }
      else
        format.html { render :action => "index" }
      end
    end
  end

  protected
  
  def check_subdomain_exists?
    not_found unless current_subdomain
  end
  
end
