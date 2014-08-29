require File.join(__FILE__, '../configured')

module Helpers
	module AutoLoader
		extend Application::Configured
		@@autoloader_path = config.auto_load_path
		def self.autoloader_path
			@@autoloader_path
		end
		def autoload(const_name, path = nil)
			const_name = const_name.to_s if const_name.is_a? Symbol
			@@autoloader_path.each do |path|
				path = File.join(path, name_to_path(const_name)) + '.rb'
				p path
				p const_name
				super const_name, path if File.file? path
			end
		end
		def name_to_path(const_name)
			const_name.gsub('::', '/').gsub(/[A-Z]/, '_\0')[1..-1].downcase
		end
	end
end