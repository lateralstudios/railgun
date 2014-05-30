module Railgun
  module Searchable
    def self.included(base)
      base.instance_eval do
        option :searchable, true
        has_scope :search, as: :keywords
      end
    end
  end
end
