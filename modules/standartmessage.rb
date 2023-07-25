# обработка обычных сообщений

class Main

	module Sortmessage

		module StandartMessage

			def prepare
				case Sortmessage.message.text
				when "/start"
					# приветственное сообщение
					SendMessage.standart_message("Приветствую тебя в боте для изучения формул по физике!Здесь ты можешь учить формулы и отслеживать статистику. Для дальнейше навигации используй /menu")


				when "/menu"
					# переход вменю, сбрасывает все текущие состояния

					Learn.learn_status = nil
					Menu.current_state = nil
					Menu.history_state = nil
					Menu.menu
				when "/stop"

					Learn.learn_status = nil
					SendMessage.standart_message("Вы вышли из режима учебы")

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

