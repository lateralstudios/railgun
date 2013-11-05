require "railgun/resource/actions"
require "railgun/resource/batch_action"
require "railgun/resource/scope"
require "railgun/resource/attributes"

####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource

    DEFAULT_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
    DEFAULT_BATCH_ACTIONS = [:batch_delete]
	
		attr_accessor :name, :resource_class, :options, 
								:sort_order, :path, :key, :actions, :member_actions, :collection_actions, :batch_actions, :scopes
								
		attr_writer :controller

		module Base
  		def initialize(resource, options = {})
  			# Customisable name
        self.name = "#{resource.name.titleize}"
        # The actual class
        self.resource_class = resource
        # Filter out the user options
        self.options = default_options.merge(options)
        # A few helper methods
        self.sort_order = options[:sort_order]
        self.path = to_path
        self.key = to_sym

        self.scopes = []
        self.add_defaults
      end
    end

    include Base
    include Actions
    include BatchActions
    include Attributes
    
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
    
    def add_defaults
    	self.scopes << Railgun::Scope.new(:all, :default => true)
    end
    
	end
end