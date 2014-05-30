module Railgun
  class Router

    def initialize(application)
      @application ||= application
    end

    def load
      railgun_application = @application
      Railgun::Engine.routes.draw do

        root to: 'dashboard#index'

        railgun_application.resources.each_pair do |key, resource|
          resources resource.resource_name.tableize.to_sym, only: resource.default_actions.map(&:key) do
            collection do
              resource.collection_actions.each do |action|
                send(action.options[:method], action.key)
              end
              send(:post, :batch_action)
            end
            member do
              resource.member_actions.each do |action|
                send(action.options[:method], action.key)
              end
            end
          end
        end
      end
    end

    def reload
      Rails.application.reload_routes!
    end
  end
end
