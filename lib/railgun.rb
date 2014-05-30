require "inherited_resources"
require "simple_form"
require "has_scope"
require "kaminari"

require "railgun/application"
require "railgun/configuration"
require "railgun/resource"
require "railgun/router"
require "railgun/engine"

####
#### This is the Railgun module.
#### It acts as the interface, passing on the primary methods to the application
####
module Railgun

  autoload :Helpers, 'railgun/railgun_controller/helpers'
  autoload :Interface, 'railgun/railgun_controller/interface'

  autoload :RailgunResource, 'railgun/resources_controller/railgun_resource'
  autoload :ResourceMethods, 'railgun/resources_controller/resource_methods'
  autoload :Dsl, 'railgun/resources_controller/dsl'
  autoload :Base, 'railgun/resources_controller/base'
  autoload :Actions, 'railgun/resources_controller/actions'
  autoload :BatchActions, 'railgun/resources_controller/batch_actions'
  autoload :Scopes, 'railgun/resources_controller/scopes'

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
  	application.prepare_reloader
  end

	def self.config
		application.config
	end

  def self.routes
    application.routes
  end

	def self.resources
  	application.resources
  end

  def self.viewable_resources
    application.viewable_resources
  end

  def self.find_resource_from_controller_name(controller)
  	symbol = Railgun::Resource.string_to_sym(controller.singularize)
  	resource = application.find_resource(symbol)
  end

  def self.mounted_at
  	config.mounted_at
  end

end

class ActionController::Base
  def self.inherit_railgun
    Railgun::RailgunController.inherit_railgun(self)
  end

  def self.load_railgun
    Railgun::ResourcesController.load_railgun(self)
  end
end
