class Autoload
	require_path 'core'
	require_path 'controllers'
	require_path 'models'
end

class Route
	get 'person/(:id)/parent/(:parent_id)', controller: :Person, action: :show
	get 'person/edit', controller: :Person, action: :edit
	get 'person/(:id)', controller: :Person, action: :show
	get 'person', controller: :Person, action: :index
end 