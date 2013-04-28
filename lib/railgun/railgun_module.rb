module Railgun
	class RailgunModule
		
		attr_accessor :module
		
		def initialize(mod, options={})
			self.module = mod
		end
		
	end
end