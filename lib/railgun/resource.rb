####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource
	
		attr_accessor :name, :resource_class, :options, :sort_order, :path
		
		def initialize(resource, options = {})
      self.name = "#{resource.name.pluralize}"
      self.resource_class = resource
      self.options = default_options.merge(options)
      self.sort_order = options[:sort_order]
      self.path = to_resource_path
    end
    
    def default_options
    	options = {
    		:type => "folder",
	    	:sort_order => Railgun.application.resources.count + 1
    	}
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