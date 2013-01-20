####
#### This is the Railgun instance
####
####
module Railgun
	class Application
	
		attr_accessor :config, :resources, :interface, :current_resource, :current_action, :active_resource
	
		@@loaded = false
		
		def config
      self.config = Configuration.new unless @config
      @config
    end
    
    def resource
			self.current_resource
		end
		
		def configure
			self.resources ||= {}
			self.config ||= Configuration.new
			self.interface ||= Interface.new(self)
		end
		
		def register_resource(resource, options = {}, &block)
			railgun_resource = find_or_create_resource(resource)
			yield(railgun_resource)
		end
		
		def load_action(action)
			self.current_action = current_resource.actions.try(:select){|a| a.key == action }.try(:first)
		end
		
		def load_active_resource(id)
			self.active_resource = current_resource.resource_class.find_by_id(id)
		end
		
		def load_resource_by_path(path)
			path_array = path.split("/") # From the namespace
			self.current_resource = self.find_resource_by_path(path_array[0])
			# Reset the resource dependant variables
			self.current_action = nil
			self.active_resource = nil
		end
		
		def find_resource_by_path(path)
			resources.find{|index, resource| resource.path == path }.try(:last)
		end
		
		def find_or_create_resource(resource)
			name = Resource.string_to_sym(resource.name)
			if resources[name]
				resources[name]
			else
				resources[name] = Resource.new(resource)
			end
			resources[name]
		end
	
		def load_railgun_paths
			return false if @@loaded
	  	files_in_load_path.each{|file| load file }
	  	@@loaded = true
	  end
	  
	  def files_in_load_path
	    config.load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
	  end
	  
	  def prevent_rails_loading_railgun_paths
		  ActiveSupport::Dependencies.autoload_paths.reject!{|path| config.load_paths.include?(path) }
		  # Don't eagerload our configs, we'll deal with them ourselves
		  Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.reject do |path|
		    config.load_paths.include?(path)
		  end
		end
	
	end
end