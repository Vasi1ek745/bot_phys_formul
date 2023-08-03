# сортировка сообщений, отделяет standartmessage от CallBack

class Main

	module Sortmessage

		attr_accessor :message , :bot, :user_id
				
		def sort_new_message(message, bot, user_id)
			
			self.message = message
			self.bot = bot
			self.user_id = user_id

			case self.message
				when Telegram::Bot::Types::CallbackQuery
				CallbackMessage.prepare
				when Telegram::Bot::Types::Message
				StandartMessage.prepare
			end


		end

    module_function(
		:sort_new_message,
        :message,
        :message=,
        :bot,
        :bot=,
        :user_id,
        :user_id=

    )	
	

	end
end