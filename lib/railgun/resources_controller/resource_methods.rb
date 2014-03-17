module Railgun
	module ResourceMethods

		def self.included(base)
			base.instance_eval do
				helper_method :railgun_resource
			end
		end

		protected

		def collection
			railgun_collection
		end

		def railgun_collection
			scope = inherited_chain
			scope = scope.page(page).per(per_page) # Apply Kaminari pagination
			scope
		end

		def inherited_chain
			end_of_association_chain
		end

		def railgun_resource
			self.class.railgun_resource
		end

	end
end
