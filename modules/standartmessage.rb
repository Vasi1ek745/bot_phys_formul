# обработка обычных сообщений

class Main

	module Sortmessage

		module StandartMessage

			def prepare
				case Sortmessage.message.text
				when "/start"
					# приветственное сообщение
					SendMessage.standart_message("Приветствую тебя в боте для изучения формул по физике! Здесь ты можешь:
												 \n - Учить формулы \n - Отслеживать статистику \n - Решать задачи")
					SendMessage.standart_message("Для навигации используй /menu")
					SendMessage.standart_message("Для полноценной работы добавьте стикеры https://t.me/addstickers/formuls_mechanics")
									

				when "/menu"
					# переход в меню

					BotLogic::Menu.reset
					BotLogic::Menu.menu

				when "/stop"

					BotLogic::Learn.learn_status = nil
					SendMessage.standart_message("Вы вышли из режима учебы")

				else 
					# проверка , начался режим учебы или нет
					if BotLogic::Learn.learn_status

						if Sortmessage.message.sticker

							BotLogic::Learn.check_answer(Sortmessage.message.sticker.file_unique_id)							

						else
							BotLogic::Learn.check_answer(Sortmessage.message.text)
						end
						
					else
					# если отправлено сообщение, а режим учебы не начался просим вернуться в меню
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

