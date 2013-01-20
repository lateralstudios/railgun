module Railgun
  class ApplicationController < ActionController::Base
  	
  	before_filter :load_resource
  	helper_method :site_name
  
  	def site_name
  		Railgun.config.site_name
  	end
  	
  	def load_resource 
  		Railgun.load_resource(request.fullpath)
  	end
  	
  end
end
