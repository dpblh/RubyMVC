class Hash
	def method_missing(method_name, *args, &block)
		if method_name =~ /(.*)=$/
			self[method_name[0..-2].to_sym] = args[0]
			return self[method_name[0..-2].to_sym]
		elsif self[method_name.to_sym]
			return self[method_name.to_sym]
		end
		super
	end
end

module Application
	module Configured
		@@config = {}
		def self.config
			@@config
		end
		def config
			@@config
		end
		def self.configured
			yield @@config
		end
	end
end

