module Railgun
	module ResourceMethods

		def self.included(base)
			base.instance_eval do
				helper_method :railgun_resource
			end
		end

		protected

		def collection
			get_collection_ivar || begin
        c = railgun_chain
        if defined?(ActiveRecord::DeprecatedFinders)
          # ActiveRecord::Base#scoped and ActiveRecord::Relation#all
          # are deprecated in Rails 4. If it's a relation just use
          # it, otherwise use .all to get a relation.
          set_collection_ivar(c.is_a?(ActiveRecord::Relation) ? c : c.all)
        else
          set_collection_ivar(c.respond_to?(:scoped) ? c.scoped : c.all)
        end
      end
		end

		def railgun_chain
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
