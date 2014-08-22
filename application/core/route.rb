require 'uri'
require 'cgi'

class Route

	attr_accessor :request, :response, :method_list
	@@routing = {
		'GET'=>[],
		'POST'=>[],
		'PUT'=>[],
		'DELETE'=>[]
	}

	def initialize (request, response)
		@request = request
		@response = response
		puts request.query
		puts method
		@method_list = @@routing[method]
		begin
			raise WEBrick::HTTPStatus::NotFound unless find_matcher 
			action = action_state
			params = build_params action[:params_id]
			execute_action action, params
			# raise WEBrick::HTTPStatus::OK
		rescue WEBrick::HTTPStatus::NotFound => e
			Controller.render '404', request, response
		rescue WEBrick::HTTPStatus::ServerError => e
			Controller.render '500', request, response
		# rescue Exception
		# 	Controller.render '500', request, response
		end
	end 

	def method
		http_method = request.request_method
		_method = request.query['_method']
		_method.upcase! unless _method.nil?
		puts "_method = #{_method}"
		puts "_http_method = #{http_method}"
		if http_method == 'GET'
			return 'GET'
		elsif http_method == 'PUT' or (http_method == 'POST' and _method == 'PUT')
			return 'PUT'
		elsif http_method == 'DELETE' or (http_method == 'POST' and _method == 'DELETE')
			return 'DELETE'
		else
			return 'POST'
		end
	end

	def self.get(url_template, hash)
		@@routing['GET'] << build_matcher(url_template, hash)
	end
	def self.post(url_template, hash)
		@@routing['POST'] << build_matcher(url_template, hash)
	end
	def self.put(url_template, hash)
		@@routing['PUT'] << build_matcher(url_template, hash)
	end
	def self.delete(url_template, hash)
		@@routing['DELETE'] << build_matcher(url_template, hash)
	end

	def self.root(hash)
		@@routing['GET'] << build_matcher('/', hash)
	end

	def find_matcher
		method_list.any?{|details| request.path =~ Regexp.new(details[:matcher])}
	end

	def build_params(action_params_id)
		params = Hash.new
		request.path[1..-1].split('/').each_with_index do |part, index|
			params[action_params_id[index]] = part unless action_params_id[index].nil?
		end
		params.merge request.query
	end

	def action_state
		method_list.find{|details| request.path =~ Regexp.new(details[:matcher])}
	end

	def self.build_matcher(url_template, hash)
		params = Hash.new
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

	def execute_action(action, params)
		controller = Object.const_get action[:controller]
		controller_instance = controller.new
		controller_instance.send 'request=', request
		controller_instance.send 'response=', response
		controller_instance.send 'params=', params
		controller_instance.send action[:action]
	end

end