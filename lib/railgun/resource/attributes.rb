module Railgun
  class Resource
    module Attributes

      attr_accessor :attributes, :name_column

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

    protected
      
      def prepare_attributes
        @attributes = []
        @name_column = nil

        if ActiveRecord::Base.connection.table_exists? resource_class.table_name
          associations = resource_class.reflect_on_all_associations
          resource_class.columns.each do |column|
            key = column.name.to_sym
            options = {:column => column, :type => column.type}

            association = associations.find{|a| a.association_foreign_key == column.name}
            if association
              options[:association] = association
            end

            # TODO: Disabled viewing relationship columns for now.. 
            options[:viewable] = !column.primary && !association
            # TODO: This should only get attr_accessible / weak attrs
            options[:editable] = !column.primary && ![:created_at, :updated_at].include?(key)

            options[:primary] = column.primary

            attribute key, options
          end
          
          @name_column = find_name_column
        end
      end

      def find_name_column
        return :title if resource_class.column_names.include?("title")
        return :name if resource_class.column_names.include?("name")
        return :username if resource_class.column_names.include?("username")
        return :id if resource_class.column_names.include?("id")
      end
      
    end
  end
  
  class Attribute
    
    attr_accessor :key, :viewable, :editable, :type, :association, :column, :options
    
    # attribute :owner, {:viewable => true, :editable => false, 
    #           :type => :integer, :association => AR_Association, :column => AR_Column
    def initialize(key, options={})
      @key = key.to_sym
      @viewable = true
      @editable = true
      @type = nil
      @association = nil
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
      @association = options.delete(:association) if options.has_key?(:association)
      @column = options.delete(:column) if options.has_key?(:column)
      @options.merge!(options)
    end
    
  end
  
end