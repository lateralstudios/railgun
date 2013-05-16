module Railgun
	class ResourcesController < RailgunController
		module Dsl
	
			def member_action action, options
				railgun_resource.dsl.member_action action, options
			end
			
		end
	end
end