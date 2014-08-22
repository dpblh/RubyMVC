class Autoload
	require_path 'db'
	require_path 'core'
	require_path 'controllers'
	require_path 'models'
end

class Route
	get 'person/(:id)/edit', controller: :Person, action: :edit
	get 'person/new', controller: :Person, action: :new
	get 'person/(:id)', controller: :Person, action: :show
	post 'person', controller: :Person, action: :create
	put 'person/(:id)', controller: :Person, action: :update
	get 'person', controller: :Person, action: :index
	delete 'person', controller: :Person, action: :delete
	root controller: :Person, action: :index
end 