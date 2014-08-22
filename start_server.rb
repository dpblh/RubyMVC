require "webrick"
require 'json'

server = WEBrick::HTTPServer.new(:Port => 1234)

server.mount_proc "/" do |request, response|
	require File.join(__FILE__, "../application/lib/autoload.rb")
	require File.join(__FILE__, "../application/config/application.rb")
	Route.new request, response
end

trap("INT") {
	server.shutdown
}

server.start