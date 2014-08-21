require "webrick"
require 'json'

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
	def do_GET (request, response)
		require File.join(__FILE__, "../application/lib/autoload.rb")
		require File.join(__FILE__, "../application/config/application.rb")
		Route.get_request(request, response)
	end

	
end

server = WEBrick::HTTPServer.new(:Port => 1234)

server.mount "/", MyServlet

trap("INT") {
	server.shutdown
}

server.start