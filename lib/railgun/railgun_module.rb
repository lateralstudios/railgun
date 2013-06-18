module Railgun
	class RailgunModule
		
		attr_accessor :module, :options, :railgun
		
		def initialize(railgun, mod, options={}, &block)
			self.railgun = railgun
			self.module = mod
			self.options = options
			yield(railgun) if block_given?
		end
		
	end
end