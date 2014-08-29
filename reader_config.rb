require 'yaml'

module ReaderConfig
	def get_config(path)
		Reader.new(YAML.load(File.open("./#{path}.yaml")))
	end

	class Reader
		attr_accessor :config
		def initialize(con={})
			@config = con
		end
		def method_missing(method, *args, &block)
			return self.class.new config[method.to_s] unless config[method.to_s].nil?
			super
		end
		def to_s
			config.to_s
		end
	end
end
