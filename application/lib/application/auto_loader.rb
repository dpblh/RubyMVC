require File.join(__FILE__, '../configured')

module Application
	module AutoLoader
		@@autoloader_path = ["#{$ROOT}application/lib/application/"]
		def self.autoloader_path
			@@autoloader_path
		end
		def autoload(const_name, path = nil)
			const_name = const_name.to_s if const_name.is_a? Symbol

			full_name = [name, const_name].join '::'

			@@autoloader_path.each do |path|
				path = File.join(path, name_to_path(full_name)) + '.rb'
				p path
				p full_name
				super full_name, path if File.file? path
			end
		end
		def name_to_path(const_name)
			const_name.gsub('::', '/').gsub(/[A-Z]/, '_\0')[1..-1].downcase
		end
	end
end