module Railgun
	class Resource
		module BatchAction
			
			
			
		end
	end
	
	class BatchAction
		
		attr_accessor :key, :options, :block
		
		def initialize(key, options = {}, &block)
			self.key = key
			self.options = options
			self.block = block
		end
		
	end
	
end