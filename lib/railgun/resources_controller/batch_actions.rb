module Railgun
	class ResourcesController < RailgunController
		module BatchActions
		
			def batch_action
				selection = params[:batch_select].map{|id| id.to_i }
				run_batch_action_block(params[:batch_method].to_sym, selection)
				respond_with(collection) do |format|
					flash[:notice] = selection.count.to_s+" "+railgun_resource.name.downcase.pluralize+" affected"
					format.html { redirect_to :action => :index}
				end
			end
			
		end				
	end
end