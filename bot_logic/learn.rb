class BotLogic

		# модуль отвечающий за логику обучения
		# переменная learn_status показывет начался режим обучения или нет, если включен то все полученые сообщения попадут суда в качестве ответов

	module Learn

			attr_accessor :learn_status, :formuls_list, :right_answer, :counter_right_answer, :step_number

			# у formuls_list следующтй формат [{"formul"=>"formul", "sticker_id"=>"sticker_id", "them_id"=>"them_id","file_unique_id"=>"file_unique_id", "them"=>"them"}]
			
		def start_learn(user_choice)
				
				# получем формулы которые выбрал user и сохраняем в db
				
				set_formuls_list(user_choice)
				
				#  Запускаем режим обучения 

				user_hash = {"user_id" => Main::Sortmessage.user_id ,"learn_status" => true, "counter_right_answer" => 0, "step_number" => 0}
				
				Database.update_user_hash(user_hash)

				# объявляем о начале
				Main::Sortmessage::SendMessage.standart_message("Первый этап, вам отправляется стикер, нужно выбрать название формулы.\nДля перехода на следующий этап нужно ответить 3 раза подряд без ошибок")
				
				# спрашиваем готовность
				Learn.first_question
		end



			def set_formuls_list(user_choice)

				# выбираем формулы из разделов которые запросил пользователь, если есть слово механика значит это все разделы
				user_choice.include?("Механика") ? formuls = Database::select_formuls_from_all_section : formuls = Database::select_formuls_for_learn_by_topics(user_choice)
				formuls_list = []			
				formuls.each { |x| formuls_list << {"formul"=>x[0], "sticker_id"=> x[1], "them_id"=> x[2],"file_unique_id"=> x[3], "them"=> x[4]} }
				user_id = Main::Sortmessage.user_id
				 # сразу заносим в db 
				Database.set_formuls_list(formuls_list, user_id)


			end
			def first_question
				Main::Sortmessage::SendMessage.inline_message(
					"Вы готовы?",
					Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [[{ text: "да" }],[{ text: "нет" }]], one_time_keyboard: true)
				)
				user_hash = {"user_id" => Main::Sortmessage.user_id, "right_answer" => "'да'"}
				Database::update_user_hash(user_hash)

			end
			def send_sticker_select_answer
				formul = Database::select_formuls_list(Main::Sortmessage.user_id).sample
				sticker_id = formul["sticker_id"]
				right_answer = "#{formul["formul"]}. #{formul["them"]}"
				user_hash = {"user_id" => Main::Sortmessage.user_id, "right_answer" => "'#{right_answer}'"}
				Database::update_user_hash(user_hash)

				Main::Sortmessage::SendMessage.sticker_message(sticker_id)
				kb = answer_keybord_generate(right_answer)
				Main::Sortmessage::SendMessage.inline_message("какая это формула?", kb)
			end
			def send_formul_select_sticker
				formul = Database::select_formuls_list(Main::Sortmessage.user_id).sample
				right_answer = formul["file_unique_id"]
				user_hash = {"user_id" => Main::Sortmessage.user_id, "right_answer" => "'#{right_answer}'"}
				Database::update_user_hash(user_hash)

				Main::Sortmessage::SendMessage.standart_message("Отправь стикер")
				Main::Sortmessage::SendMessage.standart_message("#{formul["formul"]}. #{formul["them"]}")
			end

			def check_answer(answer)

				user_hash = Database::user_hash(Main::Sortmessage.user_id)
				if user_hash["step_number"] == 0
					if answer == user_hash["right_answer"]
						Main::Sortmessage::SendMessage.standart_message("Отлично начинаем")
						step_number = 1
						user_hash = {"user_id" => Main::Sortmessage.user_id, "step_number" => step_number}
						Database::update_user_hash(user_hash)
						Learn.next_step
					else
						Main::Sortmessage::SendMessage.standart_message("Когда будете готовы отправьте да")						
					end
				else 						
					if answer == user_hash["right_answer"]

						counter_right_answer = user_hash["counter_right_answer"]+1

						user_hash = {"user_id" => Main::Sortmessage.user_id, "counter_right_answer" => counter_right_answer}
						Database::update_user_hash(user_hash)

						Main::Sortmessage::SendMessage.standart_message("Правильно")
						Main::Sortmessage::SendMessage.standart_message("#{counter_right_answer} из 3")
						Learn.next_step
					else
						counter_right_answer = 0
						user_hash = {"user_id" => Main::Sortmessage.user_id, "counter_right_answer" => counter_right_answer}
						Database::update_user_hash(user_hash)
						Main::Sortmessage::SendMessage.standart_message("Неправильно, сгорел!")
						Main::Sortmessage::SendMessage.standart_message("#{counter_right_answer} из 3")
						Learn.next_step
					end
				end
			end
			def next_step
				user_hash = Database::user_hash(Main::Sortmessage.user_id)
				counter_right_answer = user_hash["counter_right_answer"]
				step_number = user_hash["step_number"]

				if counter_right_answer == 3 
					step_number +=1
					counter_right_answer = 0
					user_hash = {"user_id" => Main::Sortmessage.user_id, "counter_right_answer" => counter_right_answer, "step_number" => step_number}
					Database::update_user_hash(user_hash)
					Main::Sortmessage::SendMessage.standart_message("Переходим к следующему этапу 💪 ")
				end

				case step_number


				when 1
					Learn.send_sticker_select_answer
				when 2
					Learn.send_formul_select_sticker
				when 3
					Main::Sortmessage::SendMessage.standart_message("Молодец ты победил!! 🥸")

				end
			end

			def answer_keybord_generate(right_answer)
				 # в конце клавиатуру перемешиваем что бы правильный ответ не был все время первым

				kb = [[{ text: right_answer }],[{ text: answer_text }],[{ text: answer_text }], [{ text: answer_text }]].sample(4)

				answers =Telegram::Bot::Types::ReplyKeyboardMarkup.new(
					keyboard: kb,
					one_time_keyboard: true
				)
			end
			def answer_text				
				formul = Database::select_formuls_list(Main::Sortmessage.user_id).sample
				answer_text = "#{formul["formul"]}. #{formul["them"]}"
			end


			module_function(
				:set_formuls_list,
				:answer_keybord_generate,
				:start_learn,
				:send_sticker_select_answer,
				:check_answer,
				:right_answer,
				:right_answer=,
				:answer_text,
				:counter_right_answer,
				:counter_right_answer=,
				:step_number,
				:step_number=,
				:send_formul_select_sticker,
				:next_step,
				:first_question
				)
			end
end