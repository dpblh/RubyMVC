class Object
	def blank?
		self.nil? or self.empty?
	end
end

class String
	def to_sql
		"\"#{self.to_s}\""
	end
	def constantize
		Object.const_get(self.to_s).new
	end
end

class Numeric
	def to_sql
		self.to_s
	end
end

class Hash
	def method_missing(method_name, *args, &block)
		if method_name =~ /(.*)=$/
			self[method_name[0..-2].to_sym] = args[0]
			return self[method_name[0..-2].to_sym]
		elsif self[method_name.to_sym]
			return self[method_name.to_sym]
		end
		super
	end
end