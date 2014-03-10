Railgun::Engine.routes.draw do

	root :to => 'dashboard#index'

	Railgun.resources.each_pair do |key, resource|
		resources resource.resource_name.demodulize.tableize.to_sym, :only => resource.default_actions.map(&:key) do
			collection do
        resource.collection_actions.each do |action|
          # eg: get :comment
          send(action.options[:method], action.key)
        end
        send(:post, :batch_action)
      end
			member do
        resource.member_actions.each do |action|
          # eg: get :comment
          send(action.options[:method], action.key)
        end
      end
		end
	end

end
