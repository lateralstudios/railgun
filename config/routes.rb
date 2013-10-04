Railgun::Engine.routes.draw do
	
	root :to => 'dashboard#index'
	
	Railgun.resources.each_pair do |key, resource|
		resources resource.to_plural_sym do
			collection do
        resource.collection_actions.each do |action|
          # eg: get :comment
          send(action.options[:method], action.key)
        end
        send(:post, :batch_action)
      end
			new do
      	resource.new_actions.each do |action|
          # eg: get :comment
          send(action.options[:method], action.key)
        end
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
