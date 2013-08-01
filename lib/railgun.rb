require "inherited_resources"
require "simple_form"
require "has_scope"
require "kaminari"

require "railgun/application"
require "railgun/interface"
require "railgun/configuration"
require "railgun/resource"
require "railgun/engine"

####
#### This is the Railgun module. 
#### It acts as the interface, passing on the primary methods to the application
####
module Railgun
	
	class << self
    
    attr_accessor :application
    
    def application
    	@application ||= ::Railgun::Application.new
    end
    
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
	
	def self.config
		application.config
	end
	
	def self.interface
		application.interface
	end
	
	def self.resources
  	application.resources
  end
  
  def self.register_resource(resource, options = {}, &block)
  	application.register_resource(resource, options, &block)
  end
  
  def self.find_resource_from_controller_name(controller)
  	symbol = Railgun::Resource.string_to_sym(controller.singularize)
  	resource = application.find_resource(symbol)
  end
  
  #TODO
  def self.inherit_railgun(controller)
  	controller.send :include, RailgunController::Helpers
  end
  
  def self.mounted_at
  	config.mounted_at
  end
	
end

class ActionController::Base
  # If you cannot inherit from InheritedResources::Base you can call
  # inherit_resource in your controller to have all the required modules and
  # funcionality included.
  def self.inherit_railgun
    Railgun.inherit_railgun(self)
  end
end
