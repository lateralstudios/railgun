module Railgun
	class ResourcesController < ApplicationController
	
		helper_method :collection, :resource, :viewable_columns, :editable_columns, :columns, :railgun_resource
		
		before_filter :prepare_layout
		
		def index
			
		end
		
		def new
			
		end
		
		def edit
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			Railgun.interface.add_crumb(:title => "Edit "+railgun_resource.name, :path => [:edit, resource])
		end
		
		def create
		
		end
		
		def update
			
		end
		
		def resource
			Railgun.active_resource
		end
		
		def collection
			beginning_of_association_scope
		end
		
		# Filter out the viewable columns
		def viewable_columns
			columns.select{|c| true }
		end
		
		# Filter out the editable columns
		def editable_columns
			columns.select{|c| !c[:primary] && !%w(created_at updated_at).include?(c[:name]) }
		end
		
		def columns
			railgun_resource.columns
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