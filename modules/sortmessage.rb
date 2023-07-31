# сортировка сообщений, отделяет standartmessage от CallBack

class Main

	module Sortmessage

		attr_accessor :message , :bot 
				
		def sort_new_message(message, bot)
			
			self.message = message
			self.bot = bot

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

    )	
	

	end
end