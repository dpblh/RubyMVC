class Route
	@@_get =[]
	@@_post =[]
	@@_put =[]
	@@_delete =[]
	def self.get(url_template, hash)
	end
	def self.post(url_template, hash)
	end
	def self.put(url_template, hash)
	end
	def self.delete(url_template, hash)
	end

	def self.get_request(request, response)
		controller_action = get_controller_action(request.path)
		controller = controller_action[:controller].new
		controller.send 'request=', request
		controller.send 'response=', response
		controller.send controller_action[:action]
	end
	def self.post_request(request, response)
	end
	def self.put_request(request, response)
	end
	def self.delete_request(request, response)
	end

	def self.get_controller_action(path)
		path = path[1..-1].split '/'
		module_name = path[0..-2].join('/') << '_controller'
		klass_name = Autoload.path_to_module(module_name.split('/'));
		klass = Object.const_get(klass_name)
		klass_method = path[1]
		{controller: klass, action: klass_method}
	end

end