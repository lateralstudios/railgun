module Railgun
		module Dsl
		
			def option key, value
				railgun_resource.options[key] = value
			end

            #actions :index, :show, :edit, :update, :destroy
            #actions :all, :except => [:new, :create]
            #actions :only => [:index, :show, :edit, :update, :destroy]    
            def actions *args
                options = args.extract_options!

                if options.has_key?(:only)
                    railgun_resource.actions = options[:only]
                else
                    if args.reject!{|a| a == :all}
                        railgun_resource.actions = Railgun::Resource::DEFAULT_ACTIONS.clone
                    elsif args.any?
                        railgun_resource.actions = args
                    end

                    if options.has_key?(:except)
                        railgun_resource.actions.reject!{|a| options[:except].include? a }
                    end
                end
                # Need to undef methods
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