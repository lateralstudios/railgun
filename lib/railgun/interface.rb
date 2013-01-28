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
		
		# Action buttons.. should these be a seperate object?
		def add_action_button_group(key, position = action_button_groups.count)
			self.action_button_groups ||= []
			group = {
				:key => key,
				:buttons => []
			}
			self.action_button_groups.insert(position, group)
			group
		end
		
		def find_action_button_group(key)
			action_button_groups.find{|g| g[:key] == key }
		end
		
		def add_action_button(group_key, title, path, *args)
			options = args.extract_options!
			group = find_action_button_group(group_key) || add_action_button_group(group_key)
			position = options.delete(:position) || group[:buttons].count
			group[:buttons].insert(position, {
				:title => title,
				:path => path,
				:type => options.delete(:type) || "info",
				:class => options.delete(:class) || "",
				:options => options
			})
		end
    
    def clear_locals
    	self.locals = {}
    end
    
    def clear_crumbs
    	self.breadcrumbs = []
    end
    
    def clear_interface_buttons
    	self.action_button_groups = []
    end
		
	end
end