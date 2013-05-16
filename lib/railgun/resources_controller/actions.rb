module Railgun
	class ResourcesController < RailgunController
		
		module Actions
			
			def self.included(base)
	    	base.extend(ClassMethods)
				base.instance_eval do
					
				end
	    end
	  
		  module ClassMethods
		  end

	  	def index(options={}, &block)
				update_action_block(:index, options, &block)
				super(options) do |format|
					@current_scope = current_scope_key
					Railgun.interface.set_title(railgun_resource.name.pluralize)
					Railgun.interface.add_action_button(:default, "Add New", [:new, railgun_resource.to_sym], :type => "info") 
					run_action_block(:index, format)
					format.html { render_railgun railgun_template("resources/index") }
				end
			end
			alias_method :index!, :index
			
			def show(options={}, &block)
				update_action_block(:show, options, &block)
				super(options) do |format|
					Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
					Railgun.interface.set_title("View "+railgun_resource.name)
					Railgun.interface.add_action_button(:default, "Edit", [:edit, resource], :type => "info")
					Railgun.interface.add_action_button(:destroy, "Delete", resource, 
						:type => "danger", :method => :delete, :confirm => "Are you sure you want to delete this record?") 
					run_action_block(:show, format)
					format.html { render_railgun railgun_template("resources/show") }
				end
			end
			alias_method :show!, :show
			
			def new(options={}, &block)
				update_action_block(:new, options, &block)
				super(options) do |format|
					Railgun.interface.add_crumb(:title => "New", :path => [:new, railgun_resource.to_sym])
					run_action_block(:new, format)
					format.html { render_railgun railgun_template("resources/new") }
				end
			end
			alias_method :new!, :new
			
			def edit(options={}, &block)
				update_action_block(:edit, options, &block)
				super(options) do |format|
					Railgun.interface.add_crumb(:title => resource.send(railgun_resource.name_column), :path => [resource])
					Railgun.interface.add_crumb(:title => "Edit", :path => [:edit, resource])
					run_action_block(:edit, format)
					format.html { render_railgun railgun_template("resources/edit") }
				end
			end
			alias_method :edit!, :edit
			
			def create(options={}, &block)
				update_action_block(:create, options, &block)
				super(options) do |success, failure|
					run_action_block(:create, success, failure)
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :create!, :create
			
			def update(options={}, &block)
				update_action_block(:update, options, &block)
				super(options) do |success, failure|
					run_action_block(:update, success, failure)
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :update!, :update
			
			def destroy(options={}, &block)
				update_action_block(:destroy, options, &block)
				super(options) do |success, failure|
					run_action_block(:destroy, success, failure)
					success.html { redirect_to :action => :index }
					success.json { render :json => resource }
				end
			end
			alias_method :destroy!, :destroy
		
		private
		
			def run_action_block(action, *format)
				action = railgun_resource.find_action(action)
				instance_exec *format, &action.block if action.block
			end
			
			def update_action_block(action, options, &block)
				action = railgun_resource.find_action(action)
				action.update(options, &block)
			end
			
			def run_batch_action_block(batch_action, selection)
				batch_action = railgun_resource.find_batch_action(batch_action)
				batch_action.block.yield(selection) if batch_action.block
			end
		  
		end
		
	end
end