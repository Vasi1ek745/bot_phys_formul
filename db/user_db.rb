class Database

		def self.user_hash(user_id)

			user_array = @db.execute("SELECT learn_status, right_answer, counter_right_answer,step_number from USERS WHERE user_id = #{user_id}")[0]
			user_hash = {"learn_status" =>user_array[0], "right_answer"=>user_array[1], "counter_right_answer"=>user_array[2],"step_number"=>user_array[3]}

		end

		def self.update_user_hash(user_hash)		
			update = ''
			user_hash.each_pair { |k,v| update+= "#{k} = #{v}," if  k != "user_id"}
			@db.execute("UPDATE Users set #{update.chop} WHERE user_id = #{user_hash["user_id"]}")

		end
		def self.set_formuls_list(formuls_list, user_id)
			formuls_list = JSON.generate(formuls_list)
			@db.execute("UPDATE Users set formuls_list = '#{formuls_list}'  WHERE user_id = #{user_id}")
		end


		def self.select_formuls_list(user_id)
			formuls_list = @db.execute(" SELECT formuls_list FROM Users WHERE user_id = #{user_id} ").flatten[0]
			formuls_list = JSON.parse(formuls_list)
		end
		
		def self.user_current_state(user_id)

			current_state = @db.execute("SELECT CURRENT_STATE FROM Users WHERE user_id = #{user_id}").flatten[0]

			curent_state = JSON.parse(current_state) if current_state != nil
			
		end 	

		def self.user_history_state(user_id)
			history_state = @db.execute("SELECT HISTORY_STATE FROM Users WHERE user_id = #{user_id}").flatten[0]
			history_state = JSON.parse(history_state) if history_state != nil
		end

		def self.change_current_state(current_state, user_id)
			current_state = JSON.generate(current_state)
			@db.execute("UPDATE Users set current_state ='#{current_state}' WHERE user_id = #{user_id} ")

		end
		def self.change_history_state(history_state, user_id)
			history_state = JSON.generate(history_state)
			@db.execute("UPDATE Users set history_state ='#{history_state}' WHERE user_id = #{user_id} ")

		end
		def self.user_current_state_reset(user_id)
			@db.execute("UPDATE Users set current_state = null WHERE user_id = #{user_id} ")
			@db.execute("UPDATE Users set HISTORY_STATE = null WHERE user_id = #{user_id} ")

		end
		def self.menu_back(user_id)
			history_state = @db.execute("SELECT HISTORY_STATE FROM Users WHERE user_id = #{user_id}").flatten[0]
			history_state = JSON.parse(history_state)

			2.times {history_state.pop}

			current_state = history_state[-1]
			current_state = JSON.generate(current_state)
			@db.execute("UPDATE Users set current_state ='#{current_state}' WHERE user_id = #{user_id} ")

			history_state = JSON.generate(history_state)
			@db.execute("UPDATE Users set history_state ='#{history_state}' WHERE user_id = #{user_id} ")

		end

end