# обработка обычных сообщений

class Main

	module Sortmessage

		module StandartMessage

			def prepare
				case Sortmessage.message.text
				when "/start"

					SendMessage.standart_message("Приветствую тебя в боте для изучения формул по физике!Здесь ты можешь учить формулы и отслеживать статистику. Для дальнейше навигации используй /menu")


				when "/menu"

					Menu.menu

				else 
					SendMessage.standart_message("команда не опознан вернитесь в меню")
				end
			end

		    module_function(
				:prepare
		    )	


		end
	end
end

