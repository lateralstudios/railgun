module Railgun
	class ResourcesController < ApplicationController
	
		helper_method :collection, :resource, :columns, :railgun_resource
		
		before_filter :prepare_layout
		
		def index
			
		end
		
		def new
			
		end
		
		def edit
			
		end
		
		def resource
			
		end
		
		def columns
			resource_class.columns
		end
		
		def collection
			beginning_of_association_scope
		end
		
		def railgun_resource 
			Railgun.resource
		end
		
protected

		def prepare_layout
			if railgun_resource.nil? 
				raise # Should be not_found
			end
			Railgun.interface.clear_crumbs
			Railgun.interface.add_crumb(:title => railgun_resource.name.pluralize, :path => [railgun_resource.resource_class])
		end
		
		def beginning_of_association_scope
			resource_class
		end
		
		def resource_class
			railgun_resource.resource_class
		end
		
	end
end