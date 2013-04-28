module Railgun
	class RailgunController < ::ActionController::Base
		
		module Methods
			
			def self.included(base)
	    	base.extend(ClassMethods)
	    	base.send :include, InstanceMethods
				base.instance_eval do
				
					layout 'railgun/application'
					before_filter :reset_interface
					before_filter :validate_admin
					helper_method :title, :site_name, :railgun_controller, :interface
					
				end
	    end
	  
		  module ClassMethods
		  	
		  	
		  	
		  end
		  
		  module InstanceMethods

		  	def title
		  		interface.title
		  	end
		  	
		  	def site_name
		  		Railgun.config.site_name
		  	end
		  	
		  	def railgun_controller
		  		params[:controller].split("railgun/").last
		  	end
		  	
		  	def interface
		  		Railgun.interface
		  	end
		  	
		  	def railgun_template(template)
		  		"railgun/"+template
		  	end
		  	
		  	def render_railgun(template)
		  		render template, :locals => Railgun.interface.locals
		  	end
		  	
		  	def validate_admin
		  		self.send(Railgun.application.config.authenticate_method)
		  	end
		  	
		  	def reset_interface
		  		interface.reset
		  	end
		  end
		  
		end
		
	end
end