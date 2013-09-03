module Railgun
	class ResourcesController < RailgunController
		module BatchActions
		
			def batch_action
				ids = (params[:batch_select] || []).map{|id| id.to_i }
				selection = resource_class.find_by_id(ids)
				send params[:batch_method].to_sym, selection
				respond_with(selection) do |format|
					flash[:notice] = selection.count.to_s+" "+railgun_resource.name.downcase.pluralize+" affected"
					format.html { redirect_to :action => :index}
				end
			end
			
			def batch_delete selection
				resource_class.find(selection).each do |resource|
    			resource.delete
    		end
    	end
    
		end				
	end
end