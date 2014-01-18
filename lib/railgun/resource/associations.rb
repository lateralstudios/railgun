module Railgun
  class Resource
    module Associations

      attr_accessor :associations

      def initialize(*args)
        super
        prepare_associations
      end

      def association(key, type, options={})
        existing = associations.find{|a|a.key == key}
        if existing
          existing.update(type, options)
        else
          associations << Association.new(key, type, options)
        end
      end

      def association_for(attribute)
        associations.find{|a| a.foreign_key == attribute.key }
      end

    protected
      
      def prepare_associations
        @associations = []
        if ActiveRecord::Base.connection.table_exists? resource_class.table_name
          reflections = resource_class.reflect_on_all_associations
          reflections.each do |reflection|
            next if reflection.macro == :has_and_belongs_to_many || reflection.options[:polymorphic]
            key = reflection.name
            type = reflection.macro
            options = {
              :klass => reflection.klass,
              :foreign_key => reflection.association_foreign_key
            }
            @associations << Association.new(key, type, options)
          end
        end
      end
      
    end
  end
  
  class Association
    
    attr_accessor :key, :type, :options
    
    def initialize(key, type, options={})
      @key = key.to_sym
      @type = type.to_sym
      @options = {}
      parse_options(options)
    end

    def klass
      @options[:klass] || @options[:class_name].try(:classify).try(:constantize) || @key.classify.constantize
    end

    def foreign_key
      (@options[:foreign_key] || @key.to_s.foreign_key).try(:to_sym)
    end

    def belongs_to? 
      @type == :belongs_to
    end
    
    def update(type, options={})
      @type = type.to_sym
      parse_options(options)
    end

    def parse_options(options)
      # TODO: optional collection and finder methods
      @options.merge!(options)
    end
    
  end
  
end