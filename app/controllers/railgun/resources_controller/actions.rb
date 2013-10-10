module Railgun
	class ResourcesController < RailgunController
		
		module Actions

	  	def index(options={}, &block)
				super(options) do |format|
					@current_scope = current_scope_key
					set_title(railgun_resource.name.pluralize)
					add_action_button(:default, "Add New", [:new, railgun_resource.to_sym], :type => "info") 
					raise action_button_groups.inspect
					instance_exec format, &block if block_given?
					format.html { render_railgun railgun_template("resources/index") }
				end
			end
			alias_method :index!, :index
			
			def show(options={}, &block)
				super(options) do |format|
					add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
					set_title("View "+railgun_resource.name)
					add_action_button(:default, "Edit", [:edit, resource], :type => "info")
					add_action_button(:destroy, "Delete", resource, 
						:type => "danger", :method => :delete, :confirm => "Are you sure you want to delete this record?") 
					instance_exec format, &block if block_given?
					format.html { render_railgun railgun_template("resources/show") }
				end
			end
			alias_method :show!, :show
			
			def new(options={}, &block)
				super(options) do |format|
					add_crumb(:title => "New", :path => [:new, railgun_resource.to_sym])
					instance_exec format, &block if block_given?
					format.html { render_railgun railgun_template("resources/new") }
				end
			end
			alias_method :new!, :new
			
			def edit(options={}, &block)
				super(options) do |format|
					add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
					add_crumb(:title => "Edit", :path => [:edit, resource])
					instance_exec format, &block if block_given?
					format.html { render_railgun railgun_template("resources/edit") }
				end
			end
			alias_method :edit!, :edit
			
			def create(options={}, &block)
				super(options) do |success, failure|
					instance_exec success, failure, &block if block_given?
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :create!, :create
			
			def update(options={}, &block)
				super(options) do |success, failure|
					instance_exec success, failure, &block if block_given?
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :update!, :update
			
			def destroy(options={}, &block)
				super(options) do |success, failure|
					instance_exec success, failure, &block if block_given?
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :destroy!, :destroy
		  
		end
		
	end
end