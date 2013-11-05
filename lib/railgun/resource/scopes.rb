module Railgun
	class Resource
		module Scopes
			
      attr_accessor :scopes

			def initialize(*args)
        super
        prepare_scopes
      end

      def scope(key, options={})
        @scopes << Scope.new(key, options)
      end

      def default_scope
        scopes.find{|s| s.default == true }
      end

    protected
			
      def prepare_scopes
        @scopes = []
        DEFAULT_SCOPES.each do |key, options|
          scope key, options
        end
      end

		end
	end
	
	class Scope
			
		attr_accessor :key, :default, :options
		
		def initialize(key, options={})
			@key = key.to_sym
			@default = false
      @options = {}
      parse_options(options)
		end

    def name
      (options[:as] || key).to_s.humanize
    end

    def update(options)
      parse_options(options)
    end

    def parse_options(options)
      options = options.clone
      @default = options.delete(:default) if options.has_key?(:default)
      @options.merge!(options)
    end
		
	end
end