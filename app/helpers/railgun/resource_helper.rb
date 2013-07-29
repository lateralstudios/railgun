module Railgun
  module ResourceHelper
  	
  	def short_format_column(resource, column)
  		case column.type
  		when :string
  			value = short_format_string_column(resource, column)
  		when :text
  			value = short_format_text_column(resource, column)
  		when :datetime
  			value = short_format_datetime_column(resource, column)
  		else
  			value = resource.try(column.name.to_sym)
  		end
  		value
  	end
  	
  	def short_format_string_column(resource, column)
  		method = column.name.to_sym
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
  	
  	def short_format_text_column(resource, column)
  		value = resource.try(column.name.to_sym)
  		truncate(value, :length => 100, :separator => ' ')
  	end
  	
  	def short_format_datetime_column(resource, column)
  		value = resource.try(column.name.to_sym)
  		pretty_datetime(value)
  	end
  	
  	def pretty_datetime(value)
  		value.strftime("%d/%m/%y %H:%M:%S")
  	end
  	
  end
end