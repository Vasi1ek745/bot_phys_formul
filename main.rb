require 'telegram/bot'
require './modules/checkmessage'
require './modules/callbackmessage'
require './modules/database'
require './modules/sendmessage'
require './modules/sortmessage'
require './modules/standartmessage'


# основной класс, запуск

class Main

  def initialize(token)
      
      @token = token

      Telegram::Bot::Client.run(@token) do |bot|

        # время запуска для проверки сообщений старое или новое
        start_bot_time = Time.now.to_i

        bot.listen do |message|
          if CheckMessage.message_is_new(start_bot_time,message)

            bot.api.send_message(
              chat_id: message.chat.id, 
              text: "Название: #{Database.setup[1][1]}"
              )
            bot.api.send_sticker(
              chat_id: message.chat.id, 
              sticker: Database.setup[1][2]
              )
           end
        end
        end
      end


end

token = File.read("./bot_token")

Main.new(token)

