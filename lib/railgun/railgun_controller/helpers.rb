module Railgun
		module Helpers
			
			def self.included(base)
	    			base.extend(ClassMethods)
	    			base.send :include, InstanceMethods
				base.instance_eval do
					layout 'railgun/application'
					before_filter :validate_admin
					before_filter :prepare
					helper_method :site_name, :railgun_controller
				end
	    		end
	  
			module ClassMethods
		  	
			end
		  
		  	module InstanceMethods
			  	
			  	def site_name
			  		Railgun.config.site_name
			  	end
			  	
			  	def railgun_controller
			  		params[:controller].split("railgun/").last
			  	end
			  	
			  	def prepare
			  		
			  	end
			  	
			  	def validate_admin
			  		self.send(Railgun.application.config.authenticate_method) if Railgun.application.config.authenticate_method
			  	end
		  	
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