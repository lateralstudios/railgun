module Railgun
	class ResourcesController < RailgunController
		module BatchActions
		
			def batch_action
				send(params[:batch_method].to_sym)
			end
			
			def batch_delete
				batch! do |selection|
	    		resource_class.find(selection).each do |resource|
	    			resource.delete
	    		end
	    	end
    	end
    	
    	def batch! options={}, &block
				selection = params[:batch_select].map{|id| id.to_i }
				yield(selection) if block_given?
				respond_with(collection) do |format|
					flash[:notice] = selection.count.to_s+" "+railgun_resource.name.downcase.pluralize+" affected"
					format.html { redirect_to :action => :index}
				end
			end
			
		end				
	end
end