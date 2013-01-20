module Railgun
  class ApplicationController < ActionController::Base
  	
  	before_filter :load_resource
  	helper_method :site_name
  
  	def site_name
  		Railgun.config.site_name
  	end
  	
  	def root_path
  		Railgun.config.mounted_path
  	end
  	
  	def load_resource 
  		Railgun.load_resource(request.fullpath, :action => params[:action], :id => params[:id])
  	end
  	
  end
end
