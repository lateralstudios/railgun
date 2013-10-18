module Railgun
		module BatchActions
		
			def batch_action
				ids = (params[:batch_select] || []).map{|id| id.to_i }
				selection = resource_class.where(:id => ids)
				number_affected = selection.count
				# TODO: THIS IS VERY INSECURE. DO NOT DO THIS!
				send params[:batch_method].to_sym, selection
				
				respond_with(selection) do |format|
					flash[:notice] = number_affected.to_s+" "+railgun_resource.name.downcase.pluralize+" affected"
					format.html { redirect_to :action => :index}
				end
			end
			
			def batch_delete selection
				selection.each do |resource|
    			resource.delete
    		end
    	end
    
		end				
end