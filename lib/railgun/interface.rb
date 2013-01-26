module Railgun
	class Interface
		
		attr_accessor :locals, :breadcrumbs
		
		def initialize(application)
      @application = application
    end
    
    def add_local(*args)
    	options = args.extract_options!
    	self.locals ||= {}
    	self.locals.merge!(options)
    end
    
    # add_crumb(*args)
		def add_crumb(*args)
			self.breadcrumbs ||= []
			crumb = {
				:title => nil,
				:path => ""
			}
			options = args.extract_options!
			crumb.merge!(options)
			self.breadcrumbs << crumb
		end
    
    def clear_locals
    	self.locals = []
    end
    
    def clear_crumbs
    	self.breadcrumbs = []
    end
		
	end
end