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
  		value = resource.try(column.name.to_sym)
  		unless value.blank?
  			if defined?(value.thumb)
  				value = content_tag :div, :class => "string-image-content" do
  					link_to value.url, :target => "_blank" do
  						image_tag(value.thumb.url) + 
  						content_tag(:p, File.basename(value.path).ellipsisize(8,8))
  					end
  				end
  			elsif value.respond_to?(:path) # See if we have a carrierwave path, extract the filename if so
  				value = File.basename(value.path).ellipsisize(8,8)
  			end
  		end
  		value.html_safe
  	end
  	
  	def short_format_text_column(resource, column)
  		value = resource.try(column.name.to_sym)
  		truncate(value, :length => 100, :separator => ' ')
  	end
  	
  	def short_format_datetime_column(resource, column)
  		value = resource.try(column.name.to_sym)
  		value.strftime("%d/%m/%y %H:%M:%S")
  	end
  	
  end
end