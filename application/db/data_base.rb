class DataBase
	@@embeded_db = [
		{
			'id'=> 1,
			'firstName'=> 'tim',
			'lastName'=> 'bay',
			'middleName'=> 'cerg'
		},
		{
			'id'=> 2,
			'firstName'=> 'tim2',
			'lastName'=> 'bay2',
			'middleName'=> 'cerg2'
		}
	]
	def self.findAll
		@@embeded_db
	end
	def self.findById(id)
		puts @@embeded_db
		@@embeded_db[id.to_i - 1]
	end
	def self.save(model)
		model['id'] = @@embeded_db.size + 1
		@@embeded_db << model
		model
	end
	def self.update(model)
		@@embeded_db[model['id']] = model
		model
	end
	def self.datete(model)
		model = @@embeded_db[model['id']]
		@@embeded_db.remove model
		nil 
	end

	def self.columns
		['lastName', 'firstName', 'middleName', 'id']
	end
	
end