class Railgun::DashboardController < Railgun::RailgunController

  def index
    add_crumb(:title => "Dashboard", :path => {:controller => 'dashboard', :action => :index} )
    set_title(site_name)
  end

end
