require "railgun/resource/actions"
require "railgun/resource/associations"
require "railgun/resource/attributes"
require "railgun/resource/batch_actions"
require "railgun/resource/scopes"

####
#### A Railgun resource
#### This relates to a Rails model, and provides all methods we can find
####
module Railgun
  class Resource

    DEFAULT_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
    DEFAULT_BATCH_ACTIONS = [[:batch_delete, {:label => "Delete"}]]
    DEFAULT_SCOPES = [[:all, {:default => true}]]
    DEFAULT_NAME_COLUMNS = [:title, :name, :username, :id]

    attr_accessor :resource_class, :options,
    :sort_order, :key, :controller

    module Base
      def initialize(resource_class, controller, options = {})
        self.resource_class = resource_class
        self.controller = controller
        self.options = default_options.merge(options)
      end
    end

    include Base
    include Actions
    include BatchActions
    include Associations
    include Attributes
    include Scopes

    def default_options
      options = {
        :icon => "folder-open",
        :sort_order => Railgun.application.resources.count + 1
      }
    end

    def name
      options[:name] || resource_name.titleize
    end

    def path
      options[:path] || resource_name.underscore.pluralize
    end

    def key
      to_sym
    end

    def to_sym
      resource_name.underscore.to_sym
    end

    def viewable?
      actions.any?{|a| a.key == :index}
    end

    def sort_order
      options[:sort_order]
    end

    def resource_name
      resource_class.name.demodulize
    end

    def controller_name
      controller.name
    end

  end
end
