# БД

require "sqlite3"

module Database

	attr_accessor :db 
	
	def self.setup(table_name,referenses_id)

		db = SQLite3::Database.new "./bd/main.db"

		return db.execute( "select * from #{table_name}" )  if table_name == "sections_physiks"
		
		references_column =	db.execute( "pragma table_info(#{table_name})")[2][1]

		db.execute( "select * from #{table_name} WHERE #{references_column} IN (#{referenses_id}) " ) 



	end

end