require "railgun/resources_controller/railgun_resource"
require "railgun/resources_controller/resource_methods"
require "railgun/resources_controller/dsl"
require "railgun/resources_controller/base"
require "railgun/resources_controller/actions"
require "railgun/resources_controller/batch_actions"
require "railgun/resources_controller/scopes"

module Railgun
	class ResourcesController < RailgunController
	
		inherit_resources
		
		respond_to :html, :js, :json, :xml
		
		extend RailgunResource
		
		include ResourceMethods
		
		extend Dsl
		
		include Base
		
		include Actions
		
		include BatchActions
		
		include Scopes
		
	end
end