require "simple_form"
require "railgun/engine"

####
#### This is the Railgun module. 
#### It acts as the interface, passing on the primary methods to the application
####
module Railgun
	
	autoload :Application, 'railgun/application'
	autoload :Interface, 'railgun/interface'
	autoload :Configuration, 'railgun/configuration'
	autoload :Resource, 'railgun/resource'
	autoload :Action, 'railgun/action'
	
	class << self
    
    attr_accessor :application
    
    def application
    	@application ||= ::Railgun::Application.new
    end
    
	end
	
	def self.config
		application.config
	end
	
	def self.interface
		application.interface
	end
	
	# The active resource
	def self.active_resource
		application.active_resource
	end
	
	# The active collection
	def self.active_collection
		
	end
	
	def self.resource
  	application.resource
  end
	
	def self.resources
  	application.resources
  end

	def self.configure
    application.configure
    yield(application.config)
    after_configure
  end
  
  def self.after_configure
  	application.prevent_rails_loading_railgun_paths
  	application.load_railgun_paths
  end
  
  def self.register_resource(resource, options = {}, &block)
  	application.register_resource(resource, options, &block)
  end
  
  def self.load_resource(path, *args)
	  options = args.extract_options!
  	path.slice!(mounted_at+"/")
  	application.load_resource_by_path(path)
  	unless resource.nil?  		
  		application.load_action(options[:action]) if options[:action]
  		application.load_active_resource(options[:id]) if options[:id]
		end
  end
  
  def self.mounted_at
  	config.mounted_at
  end
	
end
