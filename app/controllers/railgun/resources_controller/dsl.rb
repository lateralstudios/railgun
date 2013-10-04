module Railgun
	class ResourcesController < RailgunController
		module Dsl
		
			def option key, value
				railgun_resource.options[key] = value
			end
	
			def scope key, *options
	    	args = options.extract_options!
	    	railgun_resource.scopes << Railgun::Scope.new(key, args)
	    end
	    
	    def member_action(key, options = {}, &block)
	    	define_method(key, &block) if block_given?
	    	railgun_resource.member_actions << Railgun::Action.new(key, options, &block)
	    end
	    
	    def collection_action(key, options = {}, &block)
	    	define_method(key, &block) if block_given?
	    	railgun_resource.collection_actions << Railgun::Action.new(key, options, &block)
	    end
	    
	    def batch_action(key, options = {}, &block)
	    	define_method(key, &block) if block_given?
	    	railgun_resource.batch_actions << Railgun::BatchAction.new(key, options, &block)
	    end
			
		end
	end
end