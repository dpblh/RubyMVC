require File.join(__FILE__, '../auto_loader')

module Application

	extend Application::AutoLoader

	module ModelMethod

		# include ReaderConfig
		include Application::Configured

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
end