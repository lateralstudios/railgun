module Railgun
	class ResourcesController < ApplicationController
	
		helper_method :railgun_resource, :collection, :resource, :viewable_columns, :editable_columns, :columns
		
		before_filter :prepare_layout
		
		def index
			render railgun_template("resources/index")
		end
		
		def show
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			render railgun_template("resources/show")
		end
		
		def new
			render railgun_template("resources/new")
		end
		
		def edit
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			Railgun.interface.add_crumb(:title => "Edit", :path => [:edit, resource])
			render railgun_template("resources/edit")
		end
		
		def create
			
		end
		
		def update
			
		end
		
		def destroy
			
		end
		
protected		
		
		def resource
			beginning_of_association_scope.find(params[:id]) if params[:id].present?
		end
		
		def collection
			beginning_of_association_scope
		end
		
		def columns
			railgun_resource.columns
		end
		
		# Filter out the viewable columns
		def viewable_columns
			columns.select{|c| true }
		end
		
		# Filter out the editable columns
		def editable_columns
			columns.select{|c| !c[:primary] && !%w(created_at updated_at).include?(c[:name]) }
		end
		
		def railgun_resource 
			Railgun.find_resource_from_url(request.fullpath)
		end
		
		def beginning_of_association_scope
			resource_class
		end
		
		def resource_class
			railgun_resource.resource_class
		end
		
private

		def prepare_layout
			if railgun_resource.nil? 
				raise # Should be not_found
			end
			Railgun.interface.clear_crumbs
			Railgun.interface.add_crumb(:title => railgun_resource.name.pluralize, :path => [railgun_resource.resource_class])
		end
		
	end
end