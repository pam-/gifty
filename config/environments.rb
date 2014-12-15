configure :production, :development do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgresql://localhost/friends')
	ActiveRecord::Base.establish_connection(
		adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		database: db.path[1..-1],
		host: db.host,
		username: db.user,
		password: db.password,
		encoding: 'utf8'
	)
end 