module Railgun
	class Resource
		module BatchActions
			
			def initialize(*args)
        super
				prepare_batch_actions
			end
			
			def prepare_batch_actions
				@batch_actions = []
				DEFAULT_BATCH_ACTIONS.each do |batch_action|
					@batch_actions << BatchAction.new(batch_action)
				end
			end
			
		end
	end
	
	class BatchAction
		
		attr_accessor :key, :options, :block
		
		def initialize(key, options = {}, &block)
			self.key = key
			self.options = options
			self.block = block
		end
		
		def label
			options[:label] || key.to_s.humanize
		end
		
	end
	
end