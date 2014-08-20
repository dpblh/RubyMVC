class Controller
	attr_accessor :request, :response
	def send_data(data)
		@response.status = 200
		@response.body = data
	end
end