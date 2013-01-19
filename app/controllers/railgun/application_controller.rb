module Railgun
  class ApplicationController < ActionController::Base
  
  	helper_method :site_name
  
  	def site_name
  		Railgun.config.site_name
  	end
  	
  end
end
