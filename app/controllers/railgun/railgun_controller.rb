module Railgun
	class RailgunController < ::InheritedResources::Base
	
		helper_method :title, :site_name, :railgun_controller, :interface
		
		layout 'railgun/application'
		
		class << self
			attr_accessor :railgun_resource
		end
  
  	def title
  		interface.title
  	end
  	
  	def railgun_controller
  		params[:controller].split("railgun/").last
  	end
  	
  	def site_name
  		Railgun.config.site_name
  	end
  	
  	def interface
  		Railgun.interface
  	end
  	
  	def railgun_resource
      self.class.railgun_resource
    end
    helper_method :railgun_resource
  	
  	def railgun_template(template)
  		"railgun/"+template
  	end
  	
  	def render_railgun(template)
  		render template, :locals => Railgun.interface.locals
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