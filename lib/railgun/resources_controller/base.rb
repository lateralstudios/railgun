module Railgun
  module Base
    def self.included(base)
      base.instance_eval do

        before_filter :prepare_layout
        helper 'railgun/resource'

        helper_method :columns
        helper_method :viewable_columns
        helper_method :editable_columns
        helper_method :per_page
        helper_method :page
      end
    end

    protected

    def columns
      @columns ||= railgun_resource.attributes
    end

    def viewable_columns
      @viewable_columns ||= railgun_resource.viewable_columns
    end

    def editable_columns
      @editable_columns ||= railgun_resource.editable_columns
    end

    def per_page
      params[:per] || 25
    end

    def page
      (params[:page] || 1).to_i
    end

    private

    def prepare_layout
      if railgun_resource.nil?
        raise "Not found" # TODO: Should be not_found
      end
      add_crumb(:title => railgun_resource.name.pluralize, :path => [railgun_resource.resource_class])
    end
  end
end
