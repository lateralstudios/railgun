module Railgun
  module Dsl

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      def option key, value
        railgun_resource.options[key] = value
      end

      #actions :index, :show, :edit, :update, :destroy
      #actions :all, :except => [:new, :create]
      #actions :only => [:index, :show, :edit, :update, :destroy]    
      def actions *args
        options = args.extract_options!
        keys = []
        if options.has_key?(:only)
          keys = options.delete(:only)
        else
          if args.reject!{|a| a == :all}
            keys = Railgun::Resource::DEFAULT_ACTIONS.clone
          elsif args.any?
            keys = args
          end

          if options.has_key?(:except)
            except = options.delete(:except)
            keys.reject!{|a| except.include? a }
          end

          unless keys.include?(:destroy)
            railgun_resource.batch_actions.reject!{|b| b.key == :batch_delete }
          end

          keys.each do |key|
            railgun_resource.action key, :default, options
          end
        end
          # Need to undef methods
      end
                 
      def member_action(key, options = {}, &block)
        define_method(key, &block) if block_given?
        railgun_resource.member_action(key, options, &block)
      end

      def collection_action(key, options = {}, &block)
        define_method(key, &block) if block_given?
        railgun_resource.collection_action(key, options, &block)
      end

      def batch_action(key, options = {}, &block)
        define_method(key, &block) if block_given?
        railgun_resource.batch_action(key, options, &block)
      end

      def scope key, *options
        args = options.extract_options!
        railgun_resource.scopes << Railgun::Scope.new(key, args)
      end

      def attributes(*args)
        options = args.extract_options!
        args.each do |attribute|
          railgun_resource.attribute attribute, options
        end
      end
    end
  end
end