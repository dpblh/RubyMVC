require File.join __FILE__, '/../auto_loader'

module Application

	extend Application::AutoLoader

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