class PersonController < Controller
	def index
		@persons = Person.findAll
		render 'person/index'
	end
	def show
		@person = Person.findById params['id']
		puts "params id = #{@person}"
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
	def edit
		@person = Person.findById params['id']
		render 'person/edit'
	end
end