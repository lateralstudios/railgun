module Railgun
  class Resource
    module Attributes

      attr_accessor :attributes

      def initialize(*args)
        super
        prepare_attributes
      end

      def attribute(key, options)
        existing = attributes.find{|a|a.key == key}
        if existing
          existing.update(options)
        else
          attributes << Railgun::Attribute.new(key, options)
        end
      end

      def viewable_columns
        attributes.find_all{|a|a.viewable}
      end

      def editable_columns
        attributes.find_all{|a|a.editable}
      end

      def name_column
        @name_column ||= attributes.find{|a| DEFAULT_NAME_COLUMNS.include? a.key }.try(:key)
      end

    protected

      def prepare_attributes
        @attributes = []

        if ActiveRecord::Base.connection.table_exists? resource_class.table_name
          resource_class.columns.each do |column|
            key = column.name.to_sym
            options = {:column => column, :type => column.type}

            options[:viewable] = !column.primary
            # TODO: This should only get attr_accessible / weak attrs
            options[:editable] = !column.primary && ![:created_at, :updated_at].include?(key)

            options[:primary] = column.primary

            attribute key, options
          end
        end
      end

    end
  end

  class Attribute

    attr_accessor :key, :viewable, :editable, :type, :association, :column, :options

    # attribute :owner, {:viewable => true, :editable => false,
    #           :type => :integer, :column => AR_Column
    def initialize(key, options={})
      @key = key.to_sym
      @viewable = true
      @editable = true
      @type = :string
      @column = nil
      @options = {}

      parse_options(options)
    end

    def name
      key.to_s
    end

    def update(options={})
      parse_options(options)
    end

    def parse_options(options)
      options = options.clone
      @viewable = options.delete(:viewable) if options.has_key?(:viewable)
      @editable = options.delete(:editable) if options.has_key?(:editable)
      @type = options.delete(:type).to_sym if options.has_key?(:type)
      @column = options.delete(:column) if options.has_key?(:column)
      @options.merge!(options)
    end

  end

end
