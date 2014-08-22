class Controller
	attr_accessor :request, :response, :params
	def send_data(data)
		@response['Content-Type'] = 'text/javascript'
		@response.body = data
	end
	def render(view_path)
		@response['Content-Type'] = 'text/html'
		@response.body = renderer 'template' do
			ERB.new(File.read(File.join(__FILE__, "../../views/#{view_path}.html.erb"))).result(binding())
		end
	end
	def renderer(view_path)
		ERB.new(File.read(File.join(__FILE__, "../../views/#{view_path}.html.erb"))).result(binding())
	end

	def redirect(view_path)
		@response['location'] = view_path
		@response.status = 302
	end

	def self.render(view_path, request, response)
		response['Content-Type'] = 'text/html'
		response.body = ERB.new(File.read(File.join(__FILE__, "../../views/#{view_path}.html.erb"))).result(binding())
	end

end