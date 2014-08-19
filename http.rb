require 'socket'
require 'uri'

WEB_ROOT = './public'

CONTENT_TYPES = {
	'js'	=>	'text/javascript',
	'css'	=>	'text/css'
}

DEFAULT_CONTENT_TYPE = 'application/octet-stream'

def content_type(path)
	ext = File.extname(path).split('.').last
	CONTENT_TYPES.fetch ext, DEFAULT_CONTENT_TYPE
end

def request_file(request_line)
	request_uri = request_line.split(' ')[1]
	path        = URI.unescape(URI(request_uri).path)

	parts = path.split '/'

	clear = []

	parts.each do |part|
		next if part.empty? or part == '.'
		clear << part if(part != '..')
	end


	full_path = File.join WEB_ROOT, *clear
	puts full_path
	full_path
end

server = TCPServer.new 'localhost', 2345

loop do
	
	socket = server.accept

	request = socket.gets

	STDERR.puts request

	# responce = 'hello, world'

	path = request_file request

	path = File.join path, '/index.html' if File.directory? path

	if File.exists?(path) and !File.directory?(path)
		File.open(path, 'r') do |file|
			socket.print 	"HTTP/1.1 200 OK\r\n"
							"Content-Type: #{content_type(path)}\r\n"+
							"Content-Length: #{file.size}\r\n"+
							"Connection: close\r\n"

			socket.print "\r\n"

			IO.copy_stream file, socket
		end
	else
		message = 'Not Found'
		socket.print 	"HTTP/1.1 404 Not Found\r\n"
						"Content-Type: text/plain\r\n"+
						"Content-Length: #{message.size}\r\n"+
						"Connection: close\r\n"

		socket.print "\r\n"

		socket.print message

	end

	socket.close

end