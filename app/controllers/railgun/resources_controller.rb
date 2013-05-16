require "railgun/resources_controller/interface"
require "railgun/resources_controller/actions"
require "railgun/resources_controller/batch_actions"
require "railgun/resources_controller/railgun_resource"
require "railgun/resources_controller/resource_methods"
require "railgun/resources_controller/scopes"

module Railgun
	class ResourcesController < RailgunController
	
		inherit_resources
		
		respond_to :html, :js, :json, :xml
		
		extend RailgunResource
		
		include Interface
		
		include Actions
		
		include BatchActions
		
		include ResourceMethods
		
		include Scopes
		
	end
end