class PersonController < Controller
	def index
		send_data JSON.generate(data: 'Hello, index')
	end
	def show
		send_data JSON.generate(data: params)
	end
	def edit
		send_data JSON.generate(data: :edit)
	end
end