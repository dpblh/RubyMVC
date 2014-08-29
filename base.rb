require File.join(__FILE__, '../reader_config')
require File.join(__FILE__, '../application_utils')
# require File.join(__FILE__, '../data_provider')
require File.join(__FILE__, '../auto_loader')
# p File.join(__FILE__, '../data_provider')

module Model
	module ModelMethod

		include ReaderConfig
		include Application::Configured
		extend Helpers::AutoLoader

		autoload :DataProvider

		def connector
			@connector ||= config.db.data_provider#DataProvider.new#get_config('config').data_base.data_provider.to_s.constantize
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

		def where(hash)
			klass.new.where(hash)
		end

		def method_missing(method_name, *args, &block)
			if method_name =~ /^find_by_(.*)$/
				return klass.new.send method_name, *args, &block
			end
			super
		end

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

		# private
		def materialize(hash)
			new_instance = klass.new
			hash.each do |k, v|
				new_instance.instance_variable_set("@#{k}", v)
			end
			new_instance
		end
	end

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

		def table_name
			self.class.table_name
		end

		def method_missing(method_name, *args, &block)
			if method_name =~ /^find_by_(.*)$/
				return find_by $1.split('_and_'), args
			end
			super
		end

		def to_s
			"
			#{self.instance_variables.collect {|e| e.to_s+' = '+self.instance_variable_get(e).to_s }.join(', ')}
			"
		end

		# protected

		def find_by(field_name, values)
			where(Hash[[field_name, values].transpose]).all
		end

		def all
			self.class.connector.build_query_all(table_name, select: @select, where: @where, order_by: @order_by, group_by: @group_by).collect{|row| self.class.materialize row}
		end

		def first
			self.class.connector.build_query_first(table_name, select: @select, where: @where, order_by: @order_by, group_by: @group_by).collect{|row| self.class.materialize row}
		end

		def select_all
			self.class.connector.build_query_first(table_name, select: @select, where: @where, order_by: @order_by, group_by: @group_by).collect{|hash| hash}
		end

		def select_first
			self.class.connector.build_query_first(table_name, select: @select, where: @where, order_by: @order_by, group_by: @group_by).first
		end

		def select(*args)
			@select = args
			self
		end

		def where(hash)
			@where = hash
			self
		end

		def order_by(*order)
			@order_by = order
			self
		end

		def group_by(*group)
			@group_by = group
			self
		end

		
	end

	class RecordNotFound < Exception
		def initialize(message = 'Record not found')
			super message
		end
	end
end