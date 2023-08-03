require "sqlite3"
require_relative "user_db"
require "json"


class Database

	attr_accessor :db 

	def self.initialize
		@db = SQLite3::Database.new "./db/main.db"
	end
	
	def self.data_from_table_for_button(current_state)
	
		table = current_state["position"]
		# если при вызове указан id , то делаем выборку по id если нет то вся таблица
		if current_state["current_id"]
			return @db.execute( "select #{table.chop}, id from #{table} WHERE #{current_state["previous_position"].chop}_id= #{current_state["current_id"]}" ) 
		else
			 return @db.execute( "select #{table.chop}, id from #{table}" ) 
		end
	end

	def self.next_table(table)

		tables = @db.execute("SELECT name FROM sqlite_master WHERE type='table'").flatten.map{|x| x.downcase}
		tables.delete("sqlite_sequence")
		tables[tables.index(table) + 1]
	end


	def self.user_choice_thems(current_state)		

		table = current_state["previous_position"]
		id = current_state["current_id"]		
		@db.execute("SELECT #{table.chop} from #{table} WHERE id=#{id}").flatten[0]

	end
	def self.user_choice_all(current_state)		

		table = current_state["previous_position"]
		@db.execute("SELECT #{table.chop} from #{table}").flatten

	end
	def self.user_choice_topics_with_section_id(current_state)
		table = current_state["previous_position"]
		section_id = current_state["previous_id"]	
		@db.execute("SELECT #{table.chop} from #{table} WHERE section_id=#{section_id}").flatten
	end

	# по полученому topic/topics выгружаем все формулы которые относятся к ним
	def self.select_formuls_for_learn_by_topics(topics)

		 topics = [topics] if topics.class == String

		 topics = topics.map {|topic| topic = "'#{topic}'"}.join(",")

		topic_id = @db.execute("SELECT id FROM topics where Topic in ( #{topics} )").flatten

		them_id = @db.execute("SELECT id FROM Thems WHERE topic_id  = #{topic_id[0]}").flatten

		formuls = @db.execute("SELECT formul,sticker_id,them_id,file_unique_id,Them 
									FROM Formuls,Thems 
									WHERE them_id  in ( #{them_id.join(",")}) and thems.id = them_id ")

	end

	def self.select_formuls_from_all_section
		formuls = @db.execute("SELECT formul,sticker_id,them_id,file_unique_id,Them 
									FROM Formuls,Thems 
									WHERE  thems.id = them_id ")
	end


end