class Main

	module Sortmessage

		# модуль отвечающий за логику обучения
		# переменная learn_status показывет начался режим обучения или нет, если включен то все полученые сообщения попадут суда в качестве ответов

		module Learn

			attr_accessor :learn_status, :wrong_answer, :right_answer, :mode

			
			def start_learn(user_choice)

				#  Запускаем режим обучения 

				Learn.learn_status = true

				# Получаем массив формул по выбору пользователя

				formuls_list = Learn.all_formuls_by_user_choice(user_choice)

				# formuls_list это массив c хэшами формул внутри [{"formul" => "formul", "sticker_id" => "sticker_id", "them_id" => "them_id"  }]

				
				SendMessage.standart_message("Первый этап, вам отправляются стикер, нужно выбрать название формулы.\nВсе очень просто! Для перехода на следующий этап нужно ответить 2 раза подряд без ошибок")
				sleep(1)

				formul_question = formuls_list.sample

				
				right_answer = formul_question[:formul]
				sticker_id = formul_question[:sticker_id]

				SendMessage.sticker_message(sticker_id)
				answers = answer_keybord_generate(formuls_list)
				SendMessage.inline_message("Выбери ответ", answers)

			end

			def all_formuls_by_user_choice(topics)

			# выбираем формулы из разделов которые запросил пользователь 
			formuls = Database::select_formuls_for_learn_by_topics(topics)
			# форматируем к виду [{formul:"formul", sticker_id:"sticker_id", them_id:"them_id"}]
			formuls_list = []
			
			formuls.each {|x| formuls_list << {formul:x[0], sticker_id: x[1], them_id: x[2] } }

			 formuls_list

			end

			def check_answer(answer)

			end

			def new_question

			end

			def counter

			end

			def answer_keybord_generate(answer_data_options)

				answers =Telegram::Bot::Types::ReplyKeyboardMarkup.new(
					keyboard: [[{ text: answer_data_options.sample[:formul] },{ text: answer_data_options.sample[:formul] }],
					[{ text: answer_data_options.sample[:formul] }, { text: answer_data_options.sample[:formul] }]],
					one_time_keyboard: true
				)


			end


			module_function(
				:start_learn,
				:learn_status,
				:learn_status=,
				:new_question,
				:all_formuls_by_user_choice,
				:answer_keybord_generate
				)
			end
	end
end