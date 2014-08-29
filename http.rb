

# client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "timcykahax", :database => "test")

# class Connector
# 	def self.client
# 		@client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :password => "timcykahax", :database => "test")
# 	end
# 	def self.columns(table_name)
# 		puts "show columns from #{table_name};"
# 		client.query("show columns from #{table_name};").collect {|row| row['Field']} - ['id']
# 	end
# 	def self.all(table_name)
# 		client.query "select * from #{table_name}"
# 	end
# 	def self.find(table_name, id)
# 		client.query "select * from #{table_name} where id=#{id}"
# 	end
# 	def self.save(model)
# 		client.query "insert into #{model.class.table_name} (#{model.changed_attribute.sort.join(', ')}) values (#{model.changed_attribute.sort.collect {|attr| model.class.instance_variable_get('@'+attr).to_sql }.join(', ')})"
# 	end
# 	def self.update(model)
# 		client.query "update #{model.class.table_name} set #{model.changed_attribute.sort.collect{|attr| "#{attr = model.instance_variable_get('@'+attr).to_sql}" }}"
# 	end
# end

# def Connector.client
# 	Mysql2::Client.new(:host => "localhost", :username => "root", :password => "timcykahax", :database => "test")
# end


module Model
	module ModelMethod
		def connector
			Connector
		end
		def table_name
			self.name.downcase
		end
		def all
			connector.all(table_name).collect { |row| materialize row }
		end
		def find(id)
			result = connector.find(table_name, id)
			raise RecordNotFound unless result.size > 0
			materialize result.first
		end

		@klass = nil
		def klass
			@klass ||= klass_setup 
		end

		def klass_setup
			connector.columns(table_name).each do |field|
				define_method field do
					self.class.instance_variable_get "@#{field}"
				end
				define_method "#{field}=" do |new_value|
					old_value = self.class.instance_variable_get "@#{field}"
					self.class.instance_variable_set "@#{field}", new_value
					self.changed_attribute << field if old_value != new_value and !self.changed_attribute.include? field
				end
			end
			self
		end

		private
		def materialize(hash)
			new_instance = klass.new
			hash.each do |k, v|
				new_instance.instance_variable_set("@#{k}", v)
			end
			new_instance
		end
	end

	# ModelMethod.connector = Connector

	class Base
		extend ModelMethod
		attr_reader :id

		def changed_attribute
			@changed_attribute ||= []
		end

		def save
			return true if changed_attribute.size == 0
			if new_record?
				self.class.connector.save self
			else
				self.class.connector.update self
			end
		end
		def new_record?
			id.nil?
		end

		def to_s
			"
			table_name = #{self.class.table_name}
			#{self.instance_variables.collect {|e| e.to_s+' = '+self.instance_variable_get(e).to_s }.join(', ')}
			"
		end

		
	end

	class RecordNotFound < Exception
		def initialize(message = 'Record not found')
			super message
		end
	end
end

class String
	def to_sql
		"\"#{self.to_s}\""
	end
	def constantize(class_name)
		Object.const_get(class_name)
	end
end

class Numeric
	def to_sql
		self.to_s
	end
end



class Person < Model::Base
end


# Person.connector = Connector
# Person.setup

Person.all.each {|e| puts e}

tim = Person.new
tim.lastName = 'tim'
tim.firstName = 'timtim'
tim.save
Person.find 16


# class Model

# 	attr_accessor *DataBase.columns

# 	def self.findAll
# 		DataBase.findAll
# 	end
# 	def self.findById(id)
# 		DataBase.findById id
# 	end
# 	def self.save(model)
# 		DataBase.save model
# 	end
# 	def self.update(model)
# 		DataBase.update model
# 	end
# 	def self.delete(model)
# 		DataBase.delete model
# 	end

# end