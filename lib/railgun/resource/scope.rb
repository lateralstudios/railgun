module Railgun
	class Resource
		module Scope
			
			
			
		end
	end
	
	class Scope
			
		attr_accessor :key, :default, :name
		
		def initialize(key, options={})
			self.key = key
			self.default = options[:default]
			self.name = (options[:as] || key).to_s.humanize
		end
		
	end
end