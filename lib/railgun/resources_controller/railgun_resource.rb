module Railgun
		module RailgunResource

			attr_accessor :railgun_resource

			def load_railgun_resource
				self.railgun_resource ||= Railgun.application.resource_from_controller(self)
				override_resource_class_methods! if railgun_resource
			end

			def railgun_resource=(resource)
				@railgun_resource = resource
				unless resource.nil?
					# Set inherited_resources
					defaults :resource_class => resource.resource_class
	      	#, :route_prefix => resource.route_prefix, :instance_name => resource.resource_name.singular
        end
      end

      def override_resource_class_methods!
      	self.class_eval do
	      	# Unset inherited_resource's method
	      	def self.resource_class=(klass); end

	      	def self.resource_class
	      		@railgun_resource ? @railgun_resource.resource_class : nil
	      	end
	      end
      end

      def inherited(base)
        super(base)
        base.load_railgun_resource
      end
    end
end
