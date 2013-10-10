require "railgun/railgun_controller/helpers"
require "railgun/railgun_controller/interface"
module Railgun
	class RailgunController < ::ActionController::Base
		
		include Helpers
		include Interface
  	
  end
end