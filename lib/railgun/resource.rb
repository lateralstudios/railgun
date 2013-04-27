require "railgun/dsl"
require "railgun/resource/action"
require "railgun/resource/batch_action"
require "railgun/resource/scope"

####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource
	
		attr_accessor :name, :resource_class, :columns, :viewable_columns, :editable_columns, :name_column, :options, 
								:sort_order, :path, :key, :new_actions, :member_actions, :collection_actions, :batch_actions, :scopes
								
		attr_writer :controller
		
		def initialize(resource, options = {})
			# Customisable name
      self.name = "#{resource.name}"
      # The actual class
      self.resource_class = resource
      # Process the columns
      self.columns = resource_class.columns
      self.viewable_columns = columns.select{|c| true }
      self.editable_columns = columns.select{|c| !c.primary && !%w(created_at updated_at).include?(c.name) }
      self.name_column = find_name_column
      # Filter out the user options
      self.options = default_options.merge(options)
      # A few helper methods
      self.sort_order = options[:sort_order]
      self.path = to_path
      self.key = to_sym
      # Build the actions
      self.new_actions = []
      self.member_actions = []
      self.collection_actions = []
      self.add_default_actions
      # Build the batch actions
      self.batch_actions = []
      self.add_default_batch_actions
      # Build the scopes
      self.scopes = []
      self.add_default_scopes
    end
    
    def default_options
    	options = {
    		:icon => "folder-open",
	    	:sort_order => Railgun.application.resources.count + 1
    	}
    end
    
    def controller
    	@controller ||= controller_name.constantize
    end
    
    def controller_name
    	self.class.string_to_controller_name(resource_class.name)
    end
    
    def dsl
    	@dsl ||= Railgun::DSL.new(self)
    end
    
    def actions
    	actions = [new_actions, member_actions, collection_actions].flatten!
    end
    
    def find_action(action)
    	actions.try(:find){|a| a.key == action.to_sym }
    end
    
    def find_batch_action(batch_action)
    	batch_actions.try(:find){|b| b.key == batch_action.to_sym} 
    end
    
    def default_scope
    	scopes.try(:select){|a| a.default == true }.try(:last)
    end
    
    def to_sym
    	self.class.string_to_sym(resource_class.name)
    end
    
    def to_plural_sym
	    self.class.string_to_sym(resource_class.name.pluralize)
    end
    
    def to_path
    	self.class.string_to_path(resource_class.name)
    end
    
    def self.string_to_sym(string)
    	string.underscore.to_sym
    end
    
    def self.string_to_path(string)
    	string.underscore.pluralize
    end
    
    def self.string_to_controller_name(string)
    	"Railgun::"+string.pluralize.camelize+"Controller"
    end
  
protected

		def find_name_column
    	return :title if resource_class.column_names.include?("title")
    	return :name if resource_class.column_names.include?("name")
    	return :username if resource_class.column_names.include?("username")
    	return :id if resource_class.column_names.include?("id")
    end
    
    def add_default_actions
    	default_actions = [:new, :create, :show, :edit, :update, :destroy, :index]
    	default_actions.each do |action|
	    	case action
	    	when :new
	    		self.new_actions << Railgun::Action.new(action, :method => :get) if [:new].include?(action)
	    		self.new_actions << Railgun::Action.new(action, :method => :post) if [:create].include?(action)
	    	when :show, :edit, :update, :destroy
	    		self.member_actions << Railgun::Action.new(action, :method => :get) if [:show, :edit].include?(action)
	    		self.member_actions << Railgun::Action.new(action, :method => :put) if [:update].include?(action)
	    		self.member_actions << Railgun::Action.new(action, :method => :delete) if [:destroy].include?(action)
	    	when :index, :create
	    		self.collection_actions << Railgun::Action.new(action, :method => :get) if [:index, :new].include?(action)
	    		self.collection_actions << Railgun::Action.new(action, :method => :post) if [:create].include?(action)
	    	end
	    end
    end
    
    def add_default_batch_actions
    	dsl.batch_action :delete do |selection|
    		resource_class.find(selection).each do |resource|
    			resource.delete
    		end
    	end
    end
    
    def add_default_scopes
    	dsl.scope :all, :default => true
    end
    
	end
end