# require File.join(__FILE__, '../reader_config')
# require File.join(__FILE__, '../application_utils')
# require File.join(__FILE__, '../data_provider')
require File.join(__FILE__, '../auto_loader')
# p File.join(__FILE__, '../data_provider')

module Application

	extend Application::AutoLoader

	autoload :ModelMethod

	class Base
		extend Application::ModelMethod
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