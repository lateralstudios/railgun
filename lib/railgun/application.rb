####
#### This is the Railgun instance
####
####
module Railgun
	class Application
	
		attr_accessor :config, :resources, :interface
	
		@railgun_loaded = false
		
		def config
      self.config = Configuration.new unless @config
      @config
    end
		
		def configure
			self.resources ||= {}
			self.config ||= Configuration.new
			self.interface ||= Interface.new(self)
		end
		
		def register_resource(resource, options = {}, &block)
			railgun_resource = find_or_create_resource(resource)
			register_resource_controller(railgun_resource)
			railgun_resource.dsl.run_block(&block)
		end
		
		def find_resource(symbol)
			resources[symbol] || nil
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
			return false if @railgun_loaded
	  	files_in_load_path.each{|file| load file }
	  	@railgun_loaded = true
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

private
	
		def register_resource_controller(resource)
      eval "class #{resource.controller_name} < Railgun::ResourcesController; end"
    end
	
	end
end