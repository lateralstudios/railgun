module Railgun
  class ApplicationController < ActionController::Base
  	
  	helper_method :title, :site_name, :railgun_controller
  
  	def title
  		Railgun.interface.title
  	end
  	
  	def site_name
  		Railgun.config.site_name
  	end
  	
  	def railgun_controller
  		params[:controller].split("railgun/").last
  	end
  	
  	def render_railgun(template)
  		render template, :locals => Railgun.interface.locals
  	end
  	
  	def railgun_template(template)
  		"railgun/"+template
  	end
  	
  end
end

# Add our ellipsisize method to String
class String
  def ellipsisize(minimum_length=4,edge_length=3)
    return self if self.length < minimum_length or self.length <= edge_length*2 
    edge = '.'*edge_length    
    mid_length = self.length - edge_length*2
    gsub(/(#{edge}).{#{mid_length},}(#{edge})/, '\1...\2')
  end
end