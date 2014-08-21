require 'uri'
require 'cgi'

class Route
	@@_get =[]
	@@_post =[]
	@@_put =[]
	@@_delete =[]
	def self.get(url_template, hash)
		@@_get << build_matcher(url_template, hash)
	end
	def self.post(url_template, hash)
		@@_post << build_matcher(url_template, hash)
	end
	def self.put(url_template, hash)
		@@_put << build_matcher(url_template, hash)
	end
	def self.delete(url_template, hash)
		@@_delete << build_matcher(url_template, hash)
	end

	def self.get_request(request, response)
		_request @@_get, request, response
	end
	def self.post_request(request, response)
		_request @@_post, request, response
	end
	def self.put_request(request, response)
		_request @@_put, request, response
	end
	def self.delete_request(request, response)
		_request @@_delete, request, response
	end

	def self._request(list, request, response)
		begin
			raise WEBrick::HTTPStatus::NotFound unless matcher request.path, list
			action = action_state(request.path, list);
			params = build_params request.path, action[:params_id], request.query
			execute_action(request.path, action, params, request, response)
			# raise WEBrick::HTTPStatus::OK
		rescue WEBrick::HTTPStatus::NotFound => e
			Controller.render '404', request, response
		rescue WEBrick::HTTPStatus::ServerError => e
			Controller.render '500', request, response
		# rescue Exception
		# 	Controller.render '500', request, response
		end
	end


	def self.matcher(url, list)
		list.any?{|url_matcher| url =~ Regexp.new(url_matcher[:matcher])}
	end

	def self.build_params(url, action_params_id, http_params)
		params = {}
		url[1..-1].split('/').each_with_index do |part, index|
			params[action_params_id[index]] = part unless action_params_id[index].nil?
		end
		params.merge http_params
	end

	def self.action_state(url, list)
		list.find{|item| url =~ Regexp.new(item[:matcher])}
	end

	def self.build_matcher(url_template, hash)
		params = {}
		url_template.split('/').each_with_index do |path,index|
			var = path.scan(/:(\w*)/)
			unless var.empty?
				params[index] = var.flatten.first
			end
		end
		matcher = url_template.gsub /\(:\w*\)/, '\w*'
		{
			matcher: matcher,
			params_id: params,
			controller: hash[:controller].to_s + 'Controller',
			action: hash[:action]
		}
	end

	def self.execute_action(path, action, params, request, response)
		controller = Object.const_get action[:controller]
		controller_instance = controller.new
		controller_instance.send 'request=', request
		controller_instance.send 'response=', response
		controller_instance.send 'params=', params
		controller_instance.send action[:action]
	end

end