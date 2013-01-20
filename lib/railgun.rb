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
  
  def self.find_resource_from_url(path)
  	path.slice!(mounted_at+"/") # Remove the namespace
  	resource_path = path.split("/").first # Find the resource path
  	resource = application.find_resource_by_path(resource_path)
  end
  
  def self.mounted_at
  	config.mounted_at
  end
	
end
