require 'erb'

class View
	def self.render(view_path, data={})
		@item = 'tim'
		renderer = ERB.new(File.read(File.join(__FILE__, "../../views/#{view_path}.html.erb")))
		renderer.result(binding())
	end
end