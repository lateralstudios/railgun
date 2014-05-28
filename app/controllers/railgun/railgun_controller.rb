module Railgun
  class RailgunController < ::ApplicationController
    def self.inherit_railgun(base)
      base.class_eval do
        include Railgun::Helpers
        include Railgun::Interface
      end
    end
    inherit_railgun(self)
  end
end
