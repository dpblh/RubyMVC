class Autoload
	require_path 'core'
	require_path 'controllers'
	require_path 'models'
end

class Route
	get 'person', controller: :Person, action: :index
	get 'person/(:id)', controller: :Person, action: :index
	get 'person/show', controller: :Person, action: :show
end 