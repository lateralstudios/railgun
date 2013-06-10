module Railgun
	class ResourcesController < RailgunController
		module Dsl
	
			def member_action action, *options, &block
				railgun_resource.dsl.member_action action, *options, &block
			end
			
		end
	end
end