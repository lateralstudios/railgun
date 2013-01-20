Railgun::Engine.routes.draw do

	root :to => 'dashboard#index'
	
	Railgun.resources.each_pair do |key, resource|
		resources resource.to_resource_sym, :controller => 'resources'
	end

end
