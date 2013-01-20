Railgun::Engine.routes.draw do

	root :to => 'dashboard#index'
	
	Railgun.resources.each_pair do |key, resource|
		resources resource.to_resource_sym, :controller => 'resources', :only => [] do
			new do
      	resource.new_actions.each do |action|
          # eg: get :comment
          send(action.method, action.key)
        end
      end
			member do
        resource.member_actions.each do |action|
          # eg: get :comment
          send(action.method, action.key)
        end
      end
      collection do
        resource.collection_actions.each do |action|
          # eg: get :comment
          send(action.method, action.key)
        end
      end
		end
	end

end
