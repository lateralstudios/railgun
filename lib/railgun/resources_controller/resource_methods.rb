module Railgun
	class ResourcesController < RailgunController
		
		module ResourceMethods	
		
			def self.included(base)
				base.instance_eval do
					helper_method :resource
					helper_method :collection
					helper_method :resource_class
					helper_method :railgun_resource	
				end
	    end
	  
	  protected
	  
		  def resource
				get_resource_ivar || set_resource_ivar(scoped_chain.send(method_for_find, params[:id]))
			end
			
			def collection
				get_collection_ivar || set_collection_ivar(scoped_chain.respond_to?(:scoped) ? scoped_chain.scoped : scoped_chain.all)
			end
	  
			def resource_class
	      self.class.resource_class
	    end
	    
	    def railgun_resource
	      self.class.railgun_resource
	    end
			
			def scoped_chain
				scope = inherited_chain
				scope = scope.page(params[:page]).per(params[:per]) # Apply Kaminari pagination
				scope
			end
			
			def inherited_chain
				end_of_association_chain
			end
		
		end
		
	end
end