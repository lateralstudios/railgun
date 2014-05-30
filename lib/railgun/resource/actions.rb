module Railgun
  class Resource
    module Actions

      attr_accessor :actions

      def initialize(*args)
        super
        prepare_actions
      end

      def action(key, type, options={}, &block)
        existing = actions.find{|a|a.key == key}
        if existing
          existing.update(type, options, &block)
        else
          self.actions << Action.new(key, type, options, &block)
        end
      end

      def member_action(key, options = {}, &block)
        self.actions << Railgun::Action.new(key, :member, options, &block)
      end

      def collection_action(key, options = {}, &block)
        self.actions << Railgun::Action.new(key, :collection, options, &block)
      end

      def default_actions
        actions.find_all{|a|a.type == :default}
      end

      def member_actions
        actions.find_all{|a|a.type == :member}
      end

      def collection_actions
        actions.find_all{|a|a.type == :collection}
      end

    protected

      def prepare_actions
        @actions = []
        DEFAULT_ACTIONS.clone.each do |key, options|
          action key, :default
        end
      end

    end
  end

  class Action

    attr_accessor :key, :type, :options, :block

    def initialize(key, type, options={}, &block)
      @key = key.to_sym
      @type = type.to_sym
      @options = options
      @block = block
    end

    def update(type, options={}, &block)
      @type = type.to_sym
      @options.merge!(options)
      @block = block if block
    end

  end

end
