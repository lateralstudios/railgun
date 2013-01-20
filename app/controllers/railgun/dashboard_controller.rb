class Railgun::DashboardController < Railgun::ApplicationController

	def index
		Railgun.interface.clear_crumbs
		Railgun.interface.add_crumb(:title => "Dashboard", :path => {:controller => 'dashboard', :action => :index} )
	end

end 