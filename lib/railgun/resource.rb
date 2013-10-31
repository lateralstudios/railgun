require "railgun/resource/actions"
require "railgun/resource/batch_action"
require "railgun/resource/scope"

####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource

    DEFAULT_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
	
		attr_accessor :name, :resource_class, :columns, :viewable_columns, :editable_columns, :name_column, :options, 
								:sort_order, :path, :key, :actions, :member_actions, :collection_actions, :batch_actions, :scopes
								
		attr_writer :controller

		module Base
  		def initialize(resource, options = {})
  			# Customisable name
        self.name = "#{resource.name.titleize}"
        # The actual class
        self.resource_class = resource
        process_columns
        # Filter out the user options
        self.options = default_options.merge(options)
        # A few helper methods
        self.sort_order = options[:sort_order]
        self.path = to_path
        self.key = to_sym

        self.batch_actions = []
        self.scopes = []
        self.add_defaults
      end
    end

    include Base
    include Actions
    
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
    
    def find_action(action)
    	[new_actions, member_actions, collection_actions].flatten!.try(:find){|a| a.key == action.to_sym }
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

    def process_columns
      if ActiveRecord::Base.connection.table_exists? resource_class.table_name
        self.columns = resource_class.columns
        
        # Find the associations
        associations = []
        all_associations = resource_class.reflect_on_all_associations
        belongs_to = all_associations.select { |a| a.macro == :belongs_to }
        association_foreign_keys = belongs_to.map(&:foreign_key)
        columns.each do |column|
          if association_foreign_keys.include?(column.name)
            associations << column
          end
        end
        
        # TODO: This should only get attr_accessible columns
        # TODO: Disabled viewing relationship columns for now.. 
        self.viewable_columns = columns.select{|c| !c.primary && !associations.include?(c) } 
        self.editable_columns = columns.select{|c| !c.primary && !%w(created_at updated_at).include?(c.name) }
        self.name_column = find_name_column
      end
    end

		def find_name_column
    	return :title if resource_class.column_names.include?("title")
    	return :name if resource_class.column_names.include?("name")
    	return :username if resource_class.column_names.include?("username")
    	return :id if resource_class.column_names.include?("id")
    end
    
    def add_defaults
    	self.batch_actions << Railgun::BatchAction.new(:batch_delete, :label => "Delete")
    	self.scopes << Railgun::Scope.new(:all, :default => true)
    end
    
	end
end