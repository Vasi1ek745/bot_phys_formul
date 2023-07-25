# БД

require "sqlite3"

module Database

	attr_accessor :db 
	

	def self.data_from_table_for_button(current_state)

		self.db = SQLite3::Database.new "./bd/main.db"

		table = current_state[:position]

		# если при вызове указан id , то делаем выборку по id если нет то вся таблица

		if current_state[:current_id]
			return db.execute( "select #{table.chop}, id from #{table} WHERE #{current_state[:previous_position].chop}_id= #{current_state[:current_id]}" ) 
		else
			 return db.execute( "select #{table.chop}, id from #{table}" ) 
		end
	end

	def self.next_table(table)

		tables = db.execute("SELECT name FROM sqlite_master WHERE type='table'").flatten.map{|x| x.downcase}
		tables.delete("sqlite_sequence")
		tables[tables.index(table) + 1]
	end


	def self.user_choice_thems(current_state)		

		table = current_state[:previous_position]
		id = current_state[:current_id]		
		self.db.execute("SELECT #{table.chop} from #{table} WHERE id=#{id}").flatten[0]

	end
	def self.user_choice_all(current_state)		

		table = current_state[:previous_position]
		self.db.execute("SELECT #{table.chop} from #{table}").flatten

	end
	def self.user_choice_topics_with_section_id(current_state)
		table = current_state[:previous_position]
		section_id = current_state[:previous_id]	

		self.db.execute("SELECT #{table.chop} from #{table} WHERE section_id=#{section_id}").flatten
	end

	# по полученому topic/topics выгружаем все формулы которые относятся к ним
	def self.select_formuls_for_learn_by_topics(topics)

		

		topic_id = self.db.execute("SELECT id FROM Topics WHERE Topic = '#{topics}'").flatten

		them_id = self.db.execute("SELECT id FROM Thems WHERE topic_id  = #{topic_id[0]}").flatten

		formuls = self.db.execute("SELECT formul, sticker_id,them_id FROM Formuls WHERE them_id  in ( #{them_id.join(",")} )")

	end


	module_function :db, :db=


end