# БД

require "sqlite3"

module Database

	attr :db
	
	def self.setup	

		db = SQLite3::Database.new "./bd/main.db"

		db.execute( "select * from Formuls" ) 
	end
end