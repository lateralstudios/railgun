module Railgun
	class Resource
		module BatchAction
			
			
			
		end
	end
	
	class BatchAction
		
		attr_accessor :key, :block
		
		def initialize(key, &block)
			self.key = key
			self.block = block
		end
		
	end
	
end