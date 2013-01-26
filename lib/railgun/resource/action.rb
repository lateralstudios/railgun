module Railgun
	class Resource
		module Action
			
			
			
		end
	end
	
	class Action
		
		attr_accessor :key, :options, :block
		
		def initialize(key, options={}, &block)
			self.key = key
			self.options = options
			self.block = block
		end
		
		def update(options={}, &block)
			self.options.merge!(options)
			self.block = block
		end
		
	end
	
end