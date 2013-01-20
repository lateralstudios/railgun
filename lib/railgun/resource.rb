####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource
	
		attr_accessor :name, :resource_class, :columns, :name_column, :options, 
								:sort_order, :path, :new_actions, :member_actions, :collection_actions
		
		def initialize(resource, options = {})
      self.name = "#{resource.name}"
      self.resource_class = resource
      self.columns = process_columns
      self.name_column = find_name_column
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
    		:icon => "folder-open",
	    	:sort_order => Railgun.application.resources.count + 1
    	}
    end
    
    def actions
    	actions = [new_actions, member_actions, collection_actions].flatten!
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
    
    def find_action(action)
    	actions.try(:find){|a| a.key == action.to_sym }
    end
    
    def find_record(id)
    	resource_class.find_by_id(id)
    end
    
    def add_default_actions
    	default_actions = [:new, :create, :show, :edit, :update, :destroy, :index]
    	default_actions.each do |action|
	    	case action
	    	when :new
	    		new_action(action, :method => :get) if [:new].include?(action)
	    		new_action(action, :method => :post) if [:create].include?(action)
	    	when :show, :edit, :update, :destroy
	    		member_action(action, :method => :get) if [:show, :edit].include?(action)
	    		member_action(action, :method => :put) if [:update].include?(action)
	    		member_action(action, :method => :delete) if [:destroy].include?(action)
	    	when :index, :create
	    		collection_action(action, :method => :get) if [:index, :new].include?(action)
	    		collection_action(action, :method => :post) if [:create].include?(action)
	    	end
	    end
    end
    
    def process_columns
    	columns = []
    	ar_columns = resource_class.columns
    	ar_columns.each do |ar_column|
    		columns << {
	    		:name => ar_column.name,
	    		:sql_type => ar_column.sql_type,
	    		:null => ar_column.null,
	    		:limit => ar_column.limit,
	    		:precision => ar_column.precision,
	    		:scale => ar_column.scale,
	    		:type => ar_column.type,
	    		:default => ar_column.default,
	    		:primary => ar_column.primary,
	    		:coder => ar_column.coder,
	    		:collation => ar_column.collation,
    		}
    	end
    	columns
    end
    
    def find_name_column
    	return :title if resource_class.column_names.include?("title")
    	return :name if resource_class.column_names.include?("name")
    	return :username if resource_class.column_names.include?("username")
    	return :id if resource_class.column_names.include?("id")
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