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

    def viewable_resources
      resources.select{|key, r| r.viewable? }
    end

		def find_resource(symbol)
			resources[symbol] || nil
		end

		def resource_from_controller(controller, resource_class=nil)
			resource_class ||= resource_class_from_controller(controller)
			find_or_create_resource(resource_class, controller) if resource_class
		end

		def resource_class_from_controller(controller)
			name = controller.name.demodulize.sub(/Controller$/, '').singularize
			name.safe_constantize
		end

		def find_or_create_resource(resource_class, controller)
			key = resource_class.name.demodulize.underscore.to_sym
			if resources[key]
				resources[key]
			else
				resources[key] = Resource.new(resource_class, controller)
			end
			resources[key]
		end

		def prepare_reloader
			unless Rails.application.config.cache_classes
				config.load_paths.each do |path|
  				Rails.application.config.watchable_dirs[path] = [:rb]
  			end

  			railgun_app = self

  			ActionDispatch::Reloader.to_prepare do
				  railgun_app.reload_railgun!
				end
			end
		end

		def reload_railgun!
			unload_railgun
			load_railgun
			Rails.application.reload_routes!
		end

		def load_railgun
			unless @railgun_loaded
				files_in_load_path.each{ |file| load file }
				@railgun_loaded = true
			end
		end

		def unload_railgun
			resources.each do |key, resource|
        const_name = resource.controller_name.split('::').last
        # Remove the const if its been defined
        Railgun.send(:remove_const, const_name) if Railgun.const_defined?(const_name)
      end
      @resources = {}
      @railgun_loaded = false
		end

		def files_in_load_path
			config.load_paths.flatten.compact.uniq.collect{|path| Dir["#{path}/**/*.rb"] }.flatten
		end

	end
end
