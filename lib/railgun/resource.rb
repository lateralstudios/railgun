####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
	class Resource
	
		attr_accessor :name, :options, :sort_order
		
		def initialize(resource, options = {})
      self.name = "::#{resource.name}"
      self.options = default_options.merge(options)
      self.sort_order = options[:sort_order]
    end
    
    def default_options
    	options = {
	    	:sort_order => Railgun.application.resources.count + 1
    	}
    end
    
	end
end