# БД

require "sqlite3"


		db = SQLite3::Database.new "./bd/main.db"

		a =	db.execute( "pragma table_info(topics)" )

		
