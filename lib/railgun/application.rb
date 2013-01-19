####
#### This is the Railgun instance
####
####
module Railgun
	class Application
	
		attr_accessor :config, :resources
	
		@@loaded = false
		
		def config
      self.config = Configuration.new unless @config
      @config
    end
		
		def configure
			self.resources ||= {}
			self.config ||= Configuration.new
		end
		
		def register_resource(resource, options = {}, &block)
			railgun_resource = find_or_create_resource(resource)
			yield(railgun_resource)
			raise railgun_resource.name.inspect
		end
		
		def find_or_create_resource(resource)
			name = resource.name
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