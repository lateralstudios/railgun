module Railgun
		module BatchActions
		
			def batch_action
				batch_method = params[:batch_method].to_sym
				batch_action = railgun_resource.batch_actions.find{|b| b.key == batch_method}

				if batch_action
					ids = (params[:batch_select] || []).map{|id| id.to_i }
					selection = resource_class.where(:id => ids)
					number_affected = selection.count

					# call the method
					send(batch_action.key, selection) 
				end
				
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