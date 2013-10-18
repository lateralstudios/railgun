 module Railgun
	module Interface
	
		def self.included(base)
			base.instance_eval do
				helper_method :title, :breadcrumbs, :action_button_groups, :menu_groups
			end
    		end
	
		def railgun_template(template)
			"railgun/"+template
		end
		  	
		def render_railgun(template)
			render template, :locals => @locals
		end
	
		def title
			@title ||= ""
		end
    
    		def set_title(new_title)
    			title = new_title
	    end
    
    		def add_local(*args)
    			options = args.extract_options!
    			@locals ||= {}
    			@locals.merge!(options)
    		end

		def breadcrumbs
			@breadcrumbs ||= []
		end
		
		def add_crumb(*args)
			crumb = {
				:title => nil,
				:path => ""
			}
			options = args.extract_options!
			crumb.merge!(options)
			breadcrumbs << crumb
		end
    
	    # Action buttons.. should these be a seperate object?
		
		def action_button_groups 
			@action_button_groups ||= []
		end

		def add_action_button_group(key, position = action_button_groups.count)
			group = {
				:key => key,
				:buttons => []
			}
			action_button_groups.insert(position, group)
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
    
   		# Menu buttons.. should these be a seperate object?
		def menu_groups
			@menu_groups ||= []
		end

		def add_menu_group(key, position = menu_groups.count, options = {})
			group = {
				:key => key,
				:buttons => []
			}
			menu_groups.insert(position, group)
			group
		end
		
		def find_menu_group(key)
			menu_groups.find{|g| g[:key] == key }
		end
		
		def add_menu_button(group_key, title, path, *args)
			options = args.extract_options!
			group = find_menu_group(group_key) || add_menu_group(group_key)
			position = options.delete(:position) || group[:buttons].count
			group[:buttons].insert(position, {
				:title => title,
				:path => path,
				:icon => options.delete(:icon) || "wrench",
				:class => (options[:class].present? ? "btn #{options.delete(:class)}" : "btn"),
				:options => options
			})
		end
	end
end