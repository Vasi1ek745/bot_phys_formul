# отправка сообщений
# генерация кнопок

class Main

	module Sortmessage

		module SendMessage
	
			def standart_message(message)
				chat = (defined? Sortmessage.message.chat.id) ? Sortmessage.message.chat.id : Sortmessage.message.message.chat.id
				Sortmessage.bot.api.send_message(
					chat_id: chat ,
					parse_mode: 'html',
					text: message
					)
			end	
			def sticker_message(sticker_id)
				chat = (defined? Sortmessage.message.chat.id) ? Sortmessage.message.chat.id : Sortmessage.message.message.chat.id
				Sortmessage.bot.api.send_sticker(
					chat_id: chat ,
					sticker: sticker_id
					)
			end

			def inline_message(message, kb, editless = false)
				
				chat = (defined? Sortmessage.message.chat.id) ? Sortmessage.message.chat.id : Sortmessage.message.message.chat.id
				if editless
					Sortmessage.bot.api.edit_message_text(
					  chat_id: chat ,
					  parse_mode: 'html',
					  message_id: Sortmessage.message.message.message_id,
			          text: message,
			          reply_markup: kb
			        )
		        else
				Sortmessage.bot.api.send_message(
					  chat_id: chat ,
					  parse_mode: 'html',
			          text: message,
			          reply_markup: kb
			        )
		      	end 
		      end

	      	def generate_inline_markup(kb)
	           Telegram::Bot::Types::InlineKeyboardMarkup.new(
    			  inline_keyboard: kb
        		)
	  		end


			module_function(
				:standart_message,
				:inline_message,
				:generate_inline_markup,
				:sticker_message
			)
		end
	end
end