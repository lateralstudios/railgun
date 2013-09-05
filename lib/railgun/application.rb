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
			files_in_load_path.each{|file| Rails.application.config.cache_classes ? require(file) : load(file) }
			@railgun_loaded = true
		end
		
		def files_in_load_path
			config.load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
		end
	
	end
end