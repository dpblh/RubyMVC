class PersonController < Controller
	def index
		render 'person/index', 'tim'
	end
	def show
		send_data JSON.generate(data: params)
	end
	def edit
		send_data JSON.generate(data: :edit)
	end
end