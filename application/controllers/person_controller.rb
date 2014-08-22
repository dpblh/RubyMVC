class PersonController < Controller
	def index
		@persons = Person.findAll
		render 'person/index'
	end
	def show
		@person = Person.findById params['id']
		render 'person/show'
	end
	def new
		@person = Person.new
		render 'person/new'
	end
	def create
		Person.save params
		redirect '/person'
	end
	def update
		Person.update params
		redirect "/person/#{params['id']}"
	end
	def delete
		Person.delete params
		redirect '/person'
	end
	def edit
		@person = Person.findById params['id']
		render 'person/edit'
	end
end