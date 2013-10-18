####
#### This is the Railgun instance
####
####
module Railgun
	class Application
	
		attr_accessor :config, :resources
	
		@railgun_loaded = false
		
		def config
      self.config = Configuration.new unless @config
      @config
    end
		
		def configure
			self.resources ||= {}
			self.config ||= Configuration.new
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
		
		def load_railgun
			unless @railgun_loaded
        files_in_load_path.each{ |file| load file }
        @railgun_loaded = true 
      end
		end
		
		def prepare_reloader
			unless Rails.application.config.cache_classes
				config.load_paths.each do |path|
  				Rails.application.config.watchable_dirs[path] = [:rb]
  			end
      
  			railgun_app = self
  
  			ActionDispatch::Reloader.to_prepare do
				  railgun_app.unload_railgun_paths
				  railgun_app.load_railgun
				  Rails.application.reload_routes!
				end
			end
		end
		
		def unload_railgun_paths
			resources.each do |key, resource|
        const_name = resource.controller_name.split('::').last
        # Remove the const if its been defined
        Railgun.send(:remove_const, const_name) if Railgun.const_defined?(const_name)
      end
      @resources = {}
      @railgun_loaded = false
		end
		
		def prevent_rails_loading_railgun
			#ActiveSupport::Dependencies.autoload_paths.reject!{|path| config.load_paths.include?(path) }
			#Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.reject do |path|
        		#	config.load_paths.include?(path)
      		#end
		end
		
		def files_in_load_path
			config.load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
		end
	
	end
end