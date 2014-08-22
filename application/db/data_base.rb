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
		id = model['id'].to_i
		model['id'] = id
		puts id.to_i
		@@embeded_db[id-1] = model
		puts @@embeded_db
		model
	end
	def self.delete(model)
		@@embeded_db.delete_at(model['id'].to_i - 1)
		nil 
	end

	def self.columns
		['lastName', 'firstName', 'middleName', 'id']
	end
	
end