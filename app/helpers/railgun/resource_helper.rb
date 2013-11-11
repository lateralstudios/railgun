module Railgun
  module ResourceHelper
  	
  	def short_format_attribute(resource, attribute)
      association = railgun_resource.association_for(attribute)
      if association
        return short_format_association_attribute(resource, attribute, association)
      end

  		case attribute.type
  		when :string
  			value = short_format_string_attribute(resource, attribute)
  		when :text
  			value = short_format_text_attribute(resource, attribute)
  		when :datetime
  			value = short_format_datetime_attribute(resource, attribute)
  		else
  			value = resource.try(attribute.name.to_sym)
  		end
  		value
  	end

    def short_format_association_attribute(resource, attribute, association)
      value = resource.send(attribute.key)
      if value.present? && association.type == :belongs_to
        # Need to use custom finder
        parent = association.klass.find(resource.send(attribute.key))
        name_column = Railgun::Resource::DEFAULT_NAME_COLUMNS.find{|col| parent.respond_to? col }
        parent.send(name_column)
      end
    end
  	
  	def short_format_string_attribute(resource, attribute)
  		method = attribute.key
  		if resource.respond_to?(method)
	  		resource_method = resource.method(method)
  			if resource_method.call.respond_to?(:thumb)
  				value = content_tag :div, :class => "string-image-content" do
  					link_to resource_method.call.url, :target => "_blank" do
  						image_tag(resource_method.call.thumb.url) + 
  						content_tag(:p, File.basename(resource_method.call.path).ellipsisize(8,8))
  					end
  				end
  			elsif resource_method.call.respond_to?(:path) # See if we have a carrierwave path, extract the filename if so
  				value = File.basename(resource_method.call.path).ellipsisize(8,8)
  			else
  				value = resource_method.call
  			end
  			value.html_safe
  		else
  			value
  		end
  	end
  	
  	def short_format_text_attribute(resource, attribute)
  		value = resource.try(attribute.key)
  		truncate(value, :length => 100, :separator => ' ')
  	end
  	
  	def short_format_datetime_attribute(resource, attribute)
  		value = resource.try(attribute.key)
  		pretty_datetime(value)
  	end
  	
  	def pretty_datetime(value)
  		value.strftime("%d/%m/%y %H:%M:%S")
  	end
  	
  end
end