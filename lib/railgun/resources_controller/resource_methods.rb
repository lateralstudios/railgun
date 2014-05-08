module Railgun
  module ResourceMethods
    def self.included(base)
      base.instance_eval do
        helper_method :railgun_resource
      end
    end

    protected

    def railgun_resource
      self.class.railgun_resource
    end

    def collection
      get_collection_ivar || begin
        c = paginated_chain
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

    def paginated_chain
      scope = end_of_railgun_chain
      scope = scope.page(page).per(per_page) # Apply Kaminari pagination
      scope
    end

    def end_of_railgun_chain
      railgun_chain.order('created_at DESC')
    end

    def railgun_chain
      begin_of_railgun_chain
    end

    def begin_of_railgun_chain
      end_of_association_chain
    end
  end
end
