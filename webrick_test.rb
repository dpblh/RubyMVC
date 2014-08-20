require "webrick"
require 'json'

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
	def do_GET (request, response)
		Autoload.require_path 'application/controllers'
		Autoload.require_path 'application/models'
		path = request.path[1..-1].split '/'
		module_name = path[0..-2].join('/') << '_controller'
		klass_name = Autoload.path_to_module(module_name.split('/'));
		klass = Object.const_get(klass_name)
		klass_method = path[1]
		response.status = 200
		response.body = klass.send klass_method
	end

	
end


class Autoload
	def self.autoload_path(path)
		libdirs = File.join(__FILE__, "../#{path}/**/*.rb")
		Dir[libdirs].each{ |filename| 
    		autoload(self.filename_to_module(filename, path), filename)
		}
	end
	def self.require_path(path)
		libdirs = File.join(__FILE__, "../#{path}/**/*.rb")
		puts 'start'
		puts Dir[libdirs]
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

server = WEBrick::HTTPServer.new(:Port => 1234)

server.mount "/", MyServlet

trap("INT") {
	server.shutdown
}

server.start