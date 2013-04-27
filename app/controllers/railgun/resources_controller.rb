module Railgun
	class ResourcesController < RailgunController
	
		helper 'railgun/resource'
		
		before_filter :prepare_layout
		
		respond_to :html, :js, :json, :xml
		
		layout 'railgun/application'
		
		has_scope :order, :default => "id_desc" do |controller, scope, value|
			order_params = value.split("_")
			direction = order_params.slice!(-1)
			column = order_params.join("_")
			order_string = column+" "+direction
			scope.order(order_string)
		end
		
		has_scope :scope do |controller, scope, value|
			scope.send(value)
		end
		
		class << self
      def railgun_resource=(resource)
        @railgun_resource = resource

        unless resource.nil?
          defaults :resource_class => resource.resource_class#, :route_prefix => resource.route_prefix, :instance_name => resource.resource_name.singular
        end
      end

      # Inherited Resources uses the inherited(base) hook method to
      # add in the Base.resource_class class method. To override it, we
      # need to install our resource_class method each time we're inherited from.
      def inherited(base)
        super(base)
        base.load_railgun_resource
        base.override_resource_class_methods!
      end
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
		
		def batch_action
			selection = params[:batch_select].map{|id| id.to_i }
			run_batch_action_block(params[:batch_method].to_sym, selection)
			respond_with(collection) do |format|
				flash[:notice] = selection.count.to_s+" "+railgun_resource.name.downcase.pluralize+" affected"
				format.html { redirect_to :action => :index}
			end
		end
		
		def self.load_railgun_resource
			self.railgun_resource ||= Railgun.application.find_or_create_resource(controller_name.classify.constantize)
		end
		
		def self.member_action action, options
			railgun_resource.dsl.member_action action, options
		end
		
		def self.override_resource_class_methods!
      self.class_eval do
        def self.resource_class=(klass); end

        def self.resource_class
          @railgun_resource ? @railgun_resource.resource_class : nil
        end
      end
    end
		
protected		
		
		def resource
			get_resource_ivar || set_resource_ivar(scoped_chain.send(method_for_find, params[:id]))
		end
		helper_method :resource
		
		def collection
			get_collection_ivar || set_collection_ivar(scoped_chain.respond_to?(:scoped) ? scoped_chain.scoped : scoped_chain.all)
		end
		helper_method :collection
		
		def columns
			@columns ||= railgun_resource.columns
		end
		helper_method :columns
		
		def viewable_columns
			@viewable_columns ||= railgun_resource.viewable_columns
		end
		helper_method :viewable_columns
		
		def editable_columns
			@editable_columns ||= railgun_resource.editable_columns
		end
		helper_method :editable_columns
		
		def resource_class
      self.class.resource_class
    end
    helper_method :resource_class
		
		def scoped_chain
			scope = inherited_chain
			scope = scope.page(params[:page]).per(params[:per]) # Apply Kaminari pagination
			scope = apply_scopes(scope) # Apply has_scope scopes
			scope
		end
		
		def inherited_chain
			end_of_association_chain
		end
		
		# Returns the current scope key, or default scope key
		def current_scope_key
			current_scope = params[:scope].try(:to_sym) || default_scope
		end
		
		# Find Railgun's default scope (if any)
		def default_scope
			railgun_resource.default_scope.try(:key)
		end
		
private

		def prepare_layout
			if railgun_resource.nil? 
				raise "Not found" # Should be not_found
			end
			Railgun.interface.reset
			Railgun.interface.add_crumb(:title => railgun_resource.name.pluralize, :path => [railgun_resource.resource_class])
		end
		
		def run_action_block(action, success, failure=false)
			action = railgun_resource.find_action(action)
			if action.block && !failure
				format = success unless failure
				action.block.yield(format)
			elsif action.block
				action.block.yield(success, failure)
			end
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