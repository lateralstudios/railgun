module Railgun
	class Action
		
		attr_accessor :key, :method, :action
		
		def initialize(key, options={}, &block)
			self.key = key
			self.method = options[:method]
			self.action = block
		end
		
	end
end