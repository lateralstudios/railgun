module Railgun
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

          helper_method :current_scope
					
					#scope :all, :default => true
				end
	    end			
		
			# Returns the current scope key, or default scope key
			def current_scope
				params[:scope].try(:to_sym) || railgun_resource.default_scope.try(:key)
			end
			
	end
end