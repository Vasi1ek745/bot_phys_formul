# обработка обычных сообщений

class Main

	module Sortmessage

		module StandartMessage

			def prepare
				case Sortmessage.message.text
				when "/start"

					SendMessage.standart_message("Приветствую тебя в боте для изучения формул по физике!Здесь ты можешь учить формулы и отслеживать статистику. Для дальнейше навигации используй /menu")


				when "/menu"

					Learn.learn_status = nil
					Menu.current_state = nil
					Menu.history_state = nil
					Menu.menu


				else 
					# проверка , начался режим учебы или нет
					if Learn.learn_status

						Learn.start_learn("twst")
					# если отправлено сообщение, а режим учебы не начался просим вернуться в меню
					else
						SendMessage.standart_message("команда не опознана вернитесь в меню")
					end
				end
			end

		    module_function(
				:prepare
		    )	


		end
	end
end

