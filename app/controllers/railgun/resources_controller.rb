module Railgun
	class ResourcesController < RailgunController

		def self.load_railgun(base)
      base.class_eval do
        
        inherit_resources
	
				respond_to :html, :js, :json, :xml
		
				extend Railgun::RailgunResource
				
				include Railgun::ResourceMethods
				
				include Railgun::Dsl
				
				include Railgun::Base
				
				include Railgun::Actions
				
				include Railgun::BatchActions
				
				include Railgun::Scopes
      end
    end

    load_railgun(self)
	end
end