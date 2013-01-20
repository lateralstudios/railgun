####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource
	
		attr_accessor :name, :resource_class, :options, :sort_order, :path, :actions, :new_actions, :member_actions, :collection_actions
		
		def initialize(resource, options = {})
      self.name = "#{resource.name}"
      self.resource_class = resource
      self.options = default_options.merge(options)
      self.sort_order = options[:sort_order]
      self.path = to_resource_path
      self.new_actions = []
      self.member_actions = []
      self.collection_actions = []
      self.add_default_actions
    end
    
    def default_options
    	options = {
    		:type => "folder",
	    	:sort_order => Railgun.application.resources.count + 1
    	}
    end
    
    def new_action(key, options = {}, &block)
    	self.new_actions << Action.new(key, options, &block)
    end
    
    def member_action(key, options = {}, &block)
    	self.member_actions << Action.new(key, options, &block)
    end
    
    def collection_action(key, options = {}, &block)
    	self.collection_actions << Action.new(key, options, &block)
    end
    
    def add_default_actions
    	default_actions = [:edit, :update, :destroy, :index, :new, :create]
    	default_actions.each do |action|
	    	case action
	    	when :new, :create
	    		new_action(action, :method => :get) if [:new].include?(action)
	    		new_action(action, :method => :post) if [:create].include?(action)
	    	when :edit, :update, :destroy
	    		member_action(action, :method => :get) if [:edit].include?(action)
	    		member_action(action, :method => :put) if [:update].include?(action)
	    		member_action(action, :method => :delete) if [:destroy].include?(action)
	    	when :index
	    		collection_action(action, :method => :get) if [:index, :new].include?(action)
	    		collection_action(action, :method => :post) if [:create].include?(action)
	    	end
	    end
    end
    
    def to_resource_path
    	resource_class.name.underscore.pluralize
    end
    
    def to_resource_sym
    	Resource.string_to_sym(to_resource_path)
    end
    
    def to_sym
    	Resource.string_to_sym(resource_class.name)
    end
    
    def self.string_to_sym(string)
    	string.parameterize.to_sym
    end
    
	end
end