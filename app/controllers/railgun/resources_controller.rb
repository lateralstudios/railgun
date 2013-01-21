module Railgun
	class ResourcesController < ApplicationController
	
		helper_method :railgun_resource, :collection, :resource, :viewable_columns, :editable_columns, :columns
		
		before_filter :prepare_layout
		
		def index
			render railgun_template("resources/index")
		end
		alias_method :index!, :index
		
		def show
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			render railgun_template("resources/show")
		end
		alias_method :show!, :show
		
		def new
			Railgun.interface.add_crumb(:title => "New", :path => [:new, railgun_resource.to_sym])
			render railgun_template("resources/new")
		end
		alias_method :new!, :new
		
		def edit
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			Railgun.interface.add_crumb(:title => "Edit", :path => [:edit, resource])
			render railgun_template("resources/edit")
		end
		alias_method :edit!, :edit
		
		def create
			resource = resource_class.new
			resource_params = params[railgun_resource.to_sym]
			editable_columns.each do |column|
				resource.send(column.name+"=", resource_params.try(:[], column.name))
			end
			if resource.save
				redirect_to resource, :notice => railgun_resource.name+" created successfully"
			else
				flash.now[:alert] = "There were errors in your submission. Please check the form for more details"
				render :edit, :locals => {:resource => resource}
			end
		end
		alias_method :create!, :create
		
		def update
			
		end
		alias_method :update!, :update
		
		def destroy
			
		end
		alias_method :destroy!, :destroy
		
protected		
		
		def resource
			@resource ||= beginning_of_association_scope.find(params[:id]) if params[:id].present?
		end
		
		def collection
			@collection ||= beginning_of_association_scope
		end
		
		def columns
			@columns ||= railgun_resource.columns
		end
		
		def viewable_columns
			@viewable_columns ||= railgun_resource.viewable_columns
		end
		
		def editable_columns
			@editable_columns ||= railgun_resource.editable_columns
		end
		
		def railgun_resource 
			@railgun_resource ||= Railgun.find_resource_from_url(request.fullpath)
		end
		
		def resource_class
			@resource_class ||= railgun_resource.resource_class
		end
		
		def beginning_of_association_scope
			resource_class
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