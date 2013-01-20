module Railgun
	class Interface
		
		attr_accessor :breadcrumbs
		
		def initialize(application)
      @application = application
    end
    
    def clear_crumbs
    	self.breadcrumbs = []
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
		
	end
end