class BotLogic

		# модуль отвечающий за логику обучения
		# переменная learn_status показывет начался режим обучения или нет, если включен то все полученые сообщения попадут суда в качестве ответов

		module Learn

			attr_accessor :learn_status, :formuls_list, :right_answer, :counter_right_answer, :step_number

			# у formuls_list следующтй формат [{"formul"=>"formul", "sticker_id"=>"sticker_id", "them_id"=>"them_id","file_unique_id"=>"file_unique_id", "them"=>"them"}]
			
			def start_learn(user_choice)
				
				#  Запускаем режим обучения 
				Learn.start(user_choice)

				# объявляем о начале
				Main::Sortmessage::SendMessage.standart_message("Первый этап, вам отправляется стикер, нужно выбрать название формулы.\nДля перехода на следующий этап нужно ответить 3 раза подряд без ошибок")
				# sleep(2.5)
				# спрашиваем готовность
				Learn.first_question
			end

			def start(user_choice)
				Learn.formuls_list = Learn.formuls_by_user_choice(user_choice)
				Learn.learn_status = true
				Learn.counter_right_answer = 0
				Learn.step_number = 0
				sleep(2.5)

			end


			def formuls_by_user_choice(user_choice)

				# выбираем формулы из разделов которые запросил пользователь, если есть слово механика значит это все разделы
				user_choice.include?("Механика") ? formuls = Database::select_formuls_from_all_section : formuls = Database::select_formuls_for_learn_by_topics(user_choice)
				formuls_list = []			
				formuls.each { |x| formuls_list << {"formul"=>x[0], "sticker_id"=> x[1], "them_id"=> x[2],"file_unique_id"=> x[3], "them"=> x[4]} }
				Database::change_formuls_list(Main::Sortmessage.user_id, formuls_list)
				formuls_list


			end
			def first_question
				Main::Sortmessage::SendMessage.inline_message(
					"Вы готовы?",
					Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [[{ text: "да" }],[{ text: "нет" }]], one_time_keyboard: true)
				)
				Learn.right_answer = "да"

			end
			def send_sticker_select_answer
				formul = Learn.formuls_list.sample
				sticker_id = formul["sticker_id"]
				Learn.right_answer = "#{formul["formul"]}. #{formul["them"]}"
				Main::Sortmessage::SendMessage.sticker_message(sticker_id)
				kb = answer_keybord_generate(right_answer)
				Main::Sortmessage::SendMessage.inline_message("какая это формула?", kb)
			end
			def send_formul_select_sticker
				formul = Learn.formuls_list.sample
				Learn.right_answer = formul["file_unique_id"]
				Main::Sortmessage::SendMessage.standart_message("Отправь стикер")
				Main::Sortmessage::SendMessage.standart_message("#{formul["formul"]}. #{formul["them"]}")
			end

			def check_answer(answer)

				if Learn.step_number == 0
					if answer == Learn.right_answer
						Main::Sortmessage::SendMessage.standart_message("Отлично начинаем")
						Learn.step_number = 1
						Learn.next_step
					else
						Main::Sortmessage::SendMessage.standart_message("Когда будете готовы отправьте да")						
					end
				else 						
					if answer == Learn.right_answer
						Learn.counter_right_answer+=1
						Main::Sortmessage::SendMessage.standart_message("Правильно")
						Main::Sortmessage::SendMessage.standart_message("#{Learn.counter_right_answer} из 3")
						Learn.next_step
					elsif Learn.step_number != 0
						Learn.counter_right_answer = 0
						Main::Sortmessage::SendMessage.standart_message("Неправильно, сгорел!")
						Main::Sortmessage::SendMessage.standart_message("#{Learn.counter_right_answer} из 3")
						Learn.next_step
					end
				end
			end
			def next_step
				if Learn.counter_right_answer == 3 
					Learn.step_number +=1
					Learn.counter_right_answer = 0
					Main::Sortmessage::SendMessage.standart_message("Переходим к следующему этапу 💪 ")
				end
				case Learn.step_number


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
				formul = formuls_list.sample
				answer_text = "#{formul["formul"]}. #{formul["them"]}"
			end


			module_function(
				:learn_status,
				:learn_status=,
				:formuls_list,
				:formuls_list=,
				:formuls_by_user_choice,
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
				:start,
				:first_question
				)
			end
end