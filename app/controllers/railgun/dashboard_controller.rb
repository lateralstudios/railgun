class Railgun::DashboardController < Railgun::ApplicationController

	def index
		Railgun.interface.add_crumb(:title => "Dashboard", :path => {:controller => 'dashboard', :action => :index} )
		Railgun.interface.set_title(site_name)
	end

end 