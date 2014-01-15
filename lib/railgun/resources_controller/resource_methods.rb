module Railgun
	module ResourceMethods

		def self.included(base)
			base.instance_eval do
				helper_method :resource
				helper_method :collection
				helper_method :resource_class
				helper_method :railgun_resource	
			end
		end

		protected

		def resource
			get_resource_ivar || set_resource_ivar(resource_class.send(method_for_find, params[:id]))
		end
		
		def collection
			get_collection_ivar || set_collection_ivar(railgun_chain.respond_to?(:scoped) ? railgun_chain.scoped : railgun_chain.all)
		end

		def resource_class
			self.class.resource_class
		end

		def railgun_resource
			self.class.railgun_resource
		end
		
		def railgun_chain
			scope = inherited_chain
			scope = scope.page(page).per(per_page) # Apply Kaminari pagination
			scope
		end
    alias_method :end_of_railgun_chain, :railgun_chain
		
		def inherited_chain
			end_of_association_chain
		end

	end
end