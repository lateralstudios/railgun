module Railgun
	class Interface
		
		attr_accessor :title, :locals, :breadcrumbs, :action_button_groups
		
		def initialize(application)
      @application = application
    end
    
    def reset
    	clear_locals
    	clear_crumbs
    	clear_interface_buttons
    end
    
    def set_title(title)
    	self.title = title
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
		
		def add_action_button_group(key)
			self.action_button_groups ||= {}
			self.action_button_groups[key] = {:buttons => []}
		end
		
		def add_action_button(group, title, path, *args)
			add_action_button_group(group) unless action_button_groups.try(:[], group)
			options = args.extract_options!
			self.action_button_groups[group][:buttons] << {
				:title => title,
				:path => path,
				:type => options.delete(:type) || "info",
				:class => options.delete(:class) || "",
				:options => options
			}
		end
    
    def clear_locals
    	self.locals = {}
    end
    
    def clear_crumbs
    	self.breadcrumbs = []
    end
    
    def clear_interface_buttons
    	self.action_button_groups = {}
    end
		
	end
end