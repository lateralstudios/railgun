module Railgun
		module Dsl
		
			def option key, value
				railgun_resource.options[key] = value
			end

            #actions :except => [:new, :create]
            #actions :index, :show, :edit, :update, :destroy
            #actions :only => [:index, :show, :edit, :update, :destroy]    
            def actions *args
                options = args.extract_options!
                if args.any?
                    railgun_resource.actions = args
                else
                    if options.has_key?(:except)
                        railgun_resource.actions.reject!{|a| options[:except].include? a }
                    elsif options.has_key?(:only)
                        railgun_resource.actions = options[:only]
                    end
                end
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