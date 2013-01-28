module Railgun
	class DSL
	
		def initialize(resource)
			@resource = resource
		end
		
		def resource
			@resource
		end
		
		def run_block(&block)
			instance_eval &block if block_given?
		end
		
		def controller(&block)
      resource.controller.class_eval(&block) if block_given?
      resource.controller
    end
    
    def action(set, key, options, &block)
    	set << Railgun::Action.new(key, options, &block)
    	controller do 
    		define_method(key, &block || Proc.new{})
    	end
    end
    
    def member_action(key, options = {}, &block)
   	 	action(resource.member_actions, key, options, &block)
    end
    
    def collection_action(key, options = {}, &block)
    	action(resource.collection_actions, key, options, &block)
    end
    
    def batch_action(key, &block)
    	resource.batch_actions << Railgun::BatchAction.new(key, &block)
    end
    
    def scope(key, *options)
    	args = options.extract_options!
    	resource.scopes << Railgun::Scope.new(key, args)
    end
    
    def index(options={}, &block)
	    action = resource.find_action(:index)
	    action.update(options, &block)
    end
    
    def show(options={}, &block)
	    action = resource.find_action(:show)
	    action.update(options, &block)
    end
    
    def new(options={}, &block)
	    action = resource.find_action(:new)
	    action.update(options, &block)
    end
    
    def edit(options={}, &block)
	    action = resource.find_action(:edit)
	    action.update(options, &block)
    end
    
    def create(options={}, &block)
	    action = resource.find_action(:create)
	    action.update(options, &block)
    end
    
    def update(options={}, &block)
	    action = resource.find_action(:update)
	    action.update(options, &block)
    end
    
    def destroy(options={}, &block)
	    action = resource.find_action(:destroy)
	    action.update(options, &block)
    end
		
	end
end