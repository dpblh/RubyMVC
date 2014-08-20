class Autoload

	def self.autoload_path(path)
		libdirs = File.join(__FILE__, "../../#{path}/**/*.rb")
		Dir[libdirs].each{ |filename| 
    		autoload(self.filename_to_module(filename, path), filename)
		}
	end
	def self.require_path(path)
		libdirs = File.join(__FILE__, "../../#{path}/**/*.rb")
		puts 'start'
		puts libdirs
		Dir[libdirs].each{ |filename| 
    		require filename
		}
	end
	def self.path_to_module(filename)
		path = filename.map{|item| item.split('_').map{|i| i.capitalize}.join}
		if path.size == 1
			return path[0]
		end
		path.join '::'
	end

	def self.filename_to_module(filename, path)
		filename = filename.gsub(Regexp.new("^.*\.\.\/#{path}\/"), '').gsub /\.rb/, ''
		self.path_to_module(filename.split('/'))
	end

end