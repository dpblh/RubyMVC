require File.join __FILE__, '/../application/lib/application/application_utils'
require File.join __FILE__, '/../application/lib/application/configured'
require File.join __FILE__, '/../application/lib/application/data_provider'

$ROOT = "#{__FILE__}/../"

module Application

	module Configured

		configured do |config|
			config.auto_load_path = ["#{$ROOT}lib/application/"]
			config.db = {
				data_provider: DataProvider.new
			}
		end
	end
end

p Application::Configured.config.db.data_provider

require File.join __FILE__, '/../application/lib/application/base'


class Person < Model::Base
end

# puts Person.all
puts Person.find_by_lastName_and_firstName_and_id 'tim1', 'timtim', 53
# p Person.where('lastName'=>'tim1').select('count(*)').select_first
p Model::Base.name
# tim = Person.new
# tim.firstName = 'timtim'
# tim.lastName = 'tim1'
# tim.save