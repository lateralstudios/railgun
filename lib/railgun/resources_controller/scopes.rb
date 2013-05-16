module Railgun
	class ResourcesController < RailgunController
		
		module Scopes
		
			def self.included(base)
				base.instance_eval do
					has_scope :order, :default => "id_desc" do |controller, scope, value|
						order_params = value.split("_")
						direction = order_params.slice!(-1)
						column = order_params.join("_")
						order_string = column+" "+direction
						scope.order(order_string)
					end
					
					has_scope :scope do |controller, scope, value|
						value == "all" ? scope : scope.send(value)
					end	
				end
	    end			
		
			# Returns the current scope key, or default scope key
			def current_scope_key
				current_scope = params[:scope].try(:to_sym) || default_scope
			end
			
			# Find Railgun's default scope (if any)
			def default_scope
				railgun_resource.default_scope.try(:key)
			end
			
		end
	end
end