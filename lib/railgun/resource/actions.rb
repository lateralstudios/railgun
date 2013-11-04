module Railgun
	class Resource
		module Actions

			def initialize(*args)
        super
				prepare_actions
			end
			
			def prepare_actions
				@actions = DEFAULT_ACTIONS
				@member_actions, @collection_actions = [], []
			end
			
		end
	end
	
	class Action
		
		attr_accessor :key, :options, :block
		
		def initialize(key, options={}, &block)
			@key = key
			@options = options
			@block = block
		end
		
		def update(options={}, &block)
			@options.merge!(options)
			@block = block if block
		end
		
	end
	
end