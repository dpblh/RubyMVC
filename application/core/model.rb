class Model

	attr_accessor *DataBase.columns

	def self.findAll
		DataBase.findAll
	end
	def self.findById(id)
		DataBase.findById id
	end
	def self.save(model)
		DataBase.save model
	end
	def self.update(model)
		DataBase.update model
	end
	def self.delete(model)
		DataBase.delete model
	end

end