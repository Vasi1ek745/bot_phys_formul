
# в кнопках обязательно callback в следующем формате "link_to:link_to,id:id"

class Main

	module Sortmessage

		module CallbackMessage
			# Обработка сообщений которые пришли от кнопок меню 
			# после получения CallBack, делаем из него хэш
			# меняем текущее состояние, и снова вызывем меню

			def prepare

				callback_hash = callback_to_hash(Sortmessage.message.data)
				change_curent_state(callback_hash)
				BotLogic::Menu.menu
				
			end

			def callback_to_hash(callback)
				h = {}
				callback = callback.delete(" ").split(",")
				callback.each {|x| h[x.split(":")[0]] = x.split(":")[1]}
				h
			end

			def change_curent_state(callback_hash)

				BotLogic::Menu.current_state["previous_position"] = BotLogic::Menu.current_state["position"]
				BotLogic::Menu.current_state["previous_id"] = BotLogic::Menu.current_state["current_id"]
				BotLogic::Menu.current_state["position"] = callback_hash["link_to"]
				BotLogic::Menu.current_state["current_id"] = callback_hash["id"]
				Database.change_current_state(BotLogic::Menu.current_state, Sortmessage.user_id)
				Database.change_history_state(BotLogic::Menu.history_state, Sortmessage.user_id)

			end

			module_function(
				:prepare,
				:callback_to_hash,
				:change_curent_state

			)
		end
	end
		
end