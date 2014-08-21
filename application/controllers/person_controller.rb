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
	end
	def edit
		@person = Person.findById params['id']
		render 'person/edit'
	end
end