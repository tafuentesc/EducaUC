#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
require 'active_record'
require 'uri'
configure :production do
	db = URI.parse(ENV['HEROKU_POSTGRESQL_COPPER_URL'] || 'postgres://localhost/mydb')
 
	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end

configure :development, :test do
	ActiveRecord::Base.establish_connection(
  			:adapter => 'sqlite3',
  			:database =>  'sinatra_application.sqlite3.db'
  	)
end
