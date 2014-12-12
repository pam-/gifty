configure :production, :development do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgresql://localhost/gifty')
	
end 