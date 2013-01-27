module Railgun
	class ResourcesController < ApplicationController
	
		helper_method :railgun_resource, :resource_class, :collection, :resource, :viewable_columns, :editable_columns, :columns
		
		before_filter :prepare_layout
		
		respond_to :html, :js, :json
		
		def index
			@current_scope = current_scope_key
			Railgun.interface.set_title(railgun_resource.name.pluralize)
			Railgun.interface.add_action_button(:default, "Add New", [:new, railgun_resource.to_sym], :type => "info")
			run_action_block(:index)
			render_railgun railgun_template("resources/index")
		end
		alias_method :index!, :index
		
		def show 
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			Railgun.interface.set_title("View "+railgun_resource.name)
			Railgun.interface.add_action_button(:default, "Edit", [:edit, resource], :type => "info")
			Railgun.interface.add_action_button(:destroy, "Delete", resource, :type => "danger", :method => :delete, :confirm => "Are you sure you want to delete this record?")
			run_action_block(:show)
			render_railgun railgun_template("resources/show")
		end
		alias_method :show!, :show
		
		def new
			Railgun.interface.add_crumb(:title => "New", :path => [:new, railgun_resource.to_sym])
			run_action_block(:new)
			render_railgun railgun_template("resources/new")
		end
		alias_method :new!, :new
		
		def edit
			Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
			Railgun.interface.add_crumb(:title => "Edit", :path => [:edit, resource])
			run_action_block(:edit)
			render_railgun railgun_template("resources/edit")
		end
		alias_method :edit!, :edit
		
		def create
			resource = resource_class.new
			resource_params = params[railgun_resource.to_sym]
			editable_columns.each do |column|
				resource.send(column.name+"=", resource_params.try(:[], column.name))
			end
			run_action_block(:create)
			if resource.save
				redirect_to resource, :notice => railgun_resource.name+" created successfully"
			else
				flash.now[:alert] = "There were errors in your submission. Please check the form for more details"
				render :edit, :locals => {:resource => resource}
			end
		end
		alias_method :create!, :create
		
		def update
			resource_params = params[railgun_resource.to_sym]
			editable_columns.each do |column|
				resource.send(column.name+"=", resource_params.try(:[], column.name))
			end
			run_action_block(:update)
			if resource.save
				redirect_to resource, :notice => railgun_resource.name+" updated successfully"
			else
				flash.now[:alert] = "There were errors in your submission. Please check the form for more details"
				render :edit, :locals => {:resource => resource}
			end
		end
		alias_method :update!, :update
		
		def destroy
			run_action_block(:destroy)
			resource.destroy
			unless resource.errors.any?
				respond_with(resource) do |format|
					format.html { redirect_to :index, :notice => railgun_resource.name.downcase+" deleted successfully" }
					format.json { render :json => resource }
				end
			else
				respond_with(resource) do |format|
			    format.html { redirect_to :index, :notice => "Unable to delete "+railgun_resource.name.downcase }
			    format.json { render :json => resource.errors, :status => :unprocessable_entity }
			  end
			end
		end
		alias_method :destroy!, :destroy
		
protected		
		
		def resource
			@resource ||= beginning_of_association_chain.find(params[:id]) if params[:id].present?
		end
		
		def collection
			if params[:action] == "index"
				@collection ||= apply_current_scope(end_of_association_chain) 
				@collection
			else
				nil
			end
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
			@railgun_resource ||= Railgun.find_resource_from_controller_name(railgun_controller)
		end
		
		def resource_class
			@resource_class ||= railgun_resource.resource_class
		end
		
		# Finds the current scope and applies it to [chain]
		def apply_current_scope(chain)
			end_of_railgun_scope = apply_scope(chain, current_scope_key)
			# Apply has_scope
			apply_scopes(end_of_railgun_scope)
		end
		
		# Applies a [scope] key to [chain]
		def apply_scope(chain, scope)
			chain.send(scope)
		end
		
		# Returns the current scope key, or default scope key
		def current_scope_key
			current_scope = params[:scope].try(:to_sym) || default_scope
		end
		
		# Find Railgun's default scope (if any)
		def default_scope
			railgun_resource.default_scope.try(:key)
		end
		
		# The end of our association chain, after all relationships have been applied
		def end_of_association_chain
			beginning_of_association_chain
		end
		
		# The beginning of our association chain, before all relationships are applied
		def beginning_of_association_chain
			resource_class
		end
		
private

		def prepare_layout
			if railgun_resource.nil? 
				raise "Not found" # Should be not_found
			end
			Railgun.interface.reset
			Railgun.interface.add_crumb(:title => railgun_resource.name.pluralize, :path => [railgun_resource.resource_class])
		end
		
		def run_action_block(action)
			action = railgun_resource.find_action(action)
			instance_eval &action.block if action.block
		end
		
	end
end