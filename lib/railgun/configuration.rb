####
#### The Railgun configuration
#### This stores a hash of the configuration, and makes the hash keys accessible as members
####
module Railgun
	class Configuration
		@@defaults = {
			:site_title => "Railgun",
			:mounted_at => "/railgun",
			:load_paths => [File.expand_path('app/railgun', Rails.root)]
		}
		
		cattr_accessor :settings
		
		def initialize
			@@settings ||= self.class.get_from_hash(@@defaults)
		end
		
		def self.settings
			@@settings
		end
		
		def method_missing(name, *args, &block)
      self.settings.send(name, *args, &block)
    end
    
    def self.get_from_hash(hash)
    	settings = SettingsHash.new
    	hash.each_pair do |key, value|
    		settings[key] = value.is_a?(Hash) ? self.get_from_hash(value) : value
    	end
    	settings
    end
		
	end
	
	# Thanks LocomotiveCMS for the inspiration for this bit of code :)
	class SettingsHash < Hash
	
		# Always return instances of SettingsHash
    def default(key=nil)
      include?(key) ? self[key] : self[key] = self.class.new
    end
    
    # Access keys with members
    # settings.id === settings[:id]
    # note: all keys are converted to symbols
    def method_missing(name, *args, &block)
      if name.to_s.ends_with? '='
        send :[]=, name.to_s.chomp('=').to_sym, *args
      else
        #send(:[], name.to_sym, &block)
        send(:[], name.to_sym)
      end
    end
    
	end
	
end