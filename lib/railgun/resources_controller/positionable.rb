module Railgun
  module Positionable
    def update_position
      resource.insert_at(params[:insert_at].to_i)
      render nothing: true
    end

    def self.included(base)
      base.instance_eval do
    		member_action :update_position, method: :put
      end
    end
  end
end
