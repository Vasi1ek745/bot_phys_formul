# Обработка сообщений которые пришли от кнопок 

# в кнопках обязательно callback в следующем формате "link_to:link_to,id:id"


class Main

	module Sortmessage

		module CallbackMessage
			
			# после получения CallBack, делаем из него хэш
			# меняем текущее состояние, и снова вызывем меню

			def prepare

				callback_hash = callback_to_hash(Sortmessage.message.data)
				change_curent_state(callback_hash)
				Menu.menu

				
			end

			def callback_to_hash(callback)
				h = {}
				callback = callback.delete(" ").split(",")
				callback.each {|x| h[x.split(":")[0]] = x.split(":")[1]}
				h
			end

			def change_curent_state(callback_hash)

				Menu.current_state[:previous_position] = Menu.current_state[:position]
				Menu.current_state[:previous_id] = Menu.current_state[:current_id]
				Menu.current_state[:position] = callback_hash["link_to"]
				Menu.current_state[:current_id] = callback_hash["id"]

			end

			module_function(
				:prepare,
				:callback_to_hash,
				:change_curent_state

			)
		end
	end
		
end