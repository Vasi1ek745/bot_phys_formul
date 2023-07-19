# Обработка сообщений которые пришли от кнопок 
# обязательная структура CallBack "{menu:bool , table:table_name , name:name, id:id, references:references_id }"


class Main

	module Sortmessage

		module CallbackMessage
			attr_accessor :callback_message, :callback_hash

			def prepare
				callback_hash = callback_to_hash(Sortmessage.message.data)
				if callback_hash["menu"]
					Menu.menu(callback_hash)
				else
					SendMessage.standart_message(Sortmessage.message.data)
				end
			end

			def callback_to_hash(callback)
				h = {}
				callback = callback.delete(" ").split(",")
				callback.each {|x| h[x.split(":")[0]] = x.split(":")[1]}
				h
			end

			module_function(
				:prepare,
				:callback_to_hash,
				:callback_hash,
				:callback_hash=
			)
		end
	end
		
end