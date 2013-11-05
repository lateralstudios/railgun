module Railgun
	class Resource
		module BatchActions

      attr_accessor :batch_actions
			
			def initialize(*args)
        super
				prepare_batch_actions
			end

      def batch_action(key, options={}, &block)
        existing = batch_actions.find{|a|a.key == key}
        if existing
          existing.update(options, &block)
        else
          batch_actions << Railgun::BatchAction.new(key, options, &block)
        end
      end

    protected
			
			def prepare_batch_actions
				@batch_actions = []
				DEFAULT_BATCH_ACTIONS.each do |batch_action|
					batch_action(batch_action)
				end
			end
			
		end
	end
	
	class BatchAction
		
		attr_accessor :key, :options, :block
		
		def initialize(key, options = {}, &block)
			@key = key
			@options = options
			@block = block
		end

    def label
      options[:label] || key.to_s.humanize
    end

    def update(options = {}, &block)
      @options.merge!(options)
      @block = block if block
    end
		
	end
	
end