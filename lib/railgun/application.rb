####
#### This is the Railgun instance
####
####
module Railgun
	class Application
	
		attr_accessor :config, :resources, :interface, :modules
	
		@railgun_loaded = false
		
		def config
      self.config = Configuration.new unless @config
      @config
    end
		
		def configure
			self.resources ||= {}
			self.modules ||= {}
			self.config ||= Configuration.new
			self.interface ||= Interface.new(self)
		end
		
		def register_module(mod, options = {}, &block)
			self.modules ||= {}
			modules[mod.to_s.underscore.to_sym] = RailgunModule.new(self, mod, options, &block)
		end
		
		# Make this more like register_module
		def register_resource(resource, options = {}, &block)
			if ActiveRecord::Base.connection.tables.include?(resource.to_s.tableize)
				railgun_resource = find_or_create_resource(resource)
				register_resource_controller(railgun_resource) # resource should do this?
				railgun_resource.dsl.run_block(&block)
			end
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
      resource.controller.railgun_resource = resource
    end
	
	end
end