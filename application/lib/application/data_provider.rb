require 'mysql2'
# require File.join(__FILE__, '../reader_config')

module Application
	
	class DataProvider
		# include ReaderConfig
		def client
			config = get_config('config').data_base
			@client ||= Mysql2::Client.new(:host => config.host, :username => config.username, :password => config.password, :database => config.database)
		end
		def columns(table_name)
			puts "show columns from #{table_name};"
			client.query("show columns from #{table_name};").collect {|row| row['Field']} - ['id']
		end
		def all(table_name)
			client.query "select * from #{table_name}"
		end
		def find(table_name, id)
			client.query "select * from #{table_name} where id=#{id}"
		end
		def save(model)
			client.query "insert into #{model.class.table_name} (#{model.changed_attribute.sort.join(', ')}) values (#{model.changed_attribute.sort.collect {|attr| model.class.instance_variable_get('@'+attr).to_sql }.join(', ')})"
		end
		def update(model)
			client.query "update #{model.class.table_name} set #{model.changed_attribute.sort.collect{|attr| "#{attr = model.instance_variable_get('@'+attr).to_sql}" }}"
		end
		def build_query_all(table_name, select: [], where: {}, order_by: [], group_by: [])
			select ||=[] << '*' if select.blank?
			order_by = "order by #{order_by.join(', ')}" unless order_by.blank?
			group_by = "group by #{group_by.join(', ')}" unless group_by.blank?
			select = select.join ', '
			where = where.map{|k, v| [k, v] }.collect{|v| "#{v[0]} = #{v[1].to_sql}" }.join ' and '
			p "select #{select} from #{table_name} where #{where} #{order_by} #{group_by}"
			client.query "select #{select} from #{table_name} where #{where} #{order_by} #{group_by}"
		end
		def build_query_first(table_name, select: [], where: {}, order_by: [], group_by: [])
			select ||= [] << '*' if select.blank?
			order_by = "order by #{order_by.join(', ')}" unless order_by.blank?
			group_by = "group by #{group_by.join(', ')}" unless group_by.blank?
			select = select.join ', '
			where = where.map{|k, v| [k, v] }.collect{|v| "#{v[0]} = #{v[1].to_sql}" }.join ' and '
			p "select #{select} from #{table_name} where #{where} #{order_by} #{group_by}"
			client.query "select #{select} from #{table_name} where #{where} #{order_by} #{group_by} limit 1"
		end
	end
end
