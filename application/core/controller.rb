class Controller
	attr_accessor :request, :response, :params
	def send_data(data)
		@response['Content-Type'] = 'text/javascript'
		@response.body = data
	end
	def render(view_path, data={})
		@response['Content-Type'] = 'text/html'
		@response.body = View.render view_path
	end
end