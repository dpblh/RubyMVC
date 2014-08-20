class PersonController
	def self.index()
		JSON.generate(data: 'Hello, index')
	end
	def self.show()
		JSON.generate(data: Person.getName)
	end
end