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
          if Security.message_is_new(start_bot_time,message)
          case message.text
          when '/start'
            bot.api.send_message(
              chat_id: message.chat.id, 
              text: "test",
              )

          end
        end
        end
      end
     end

end

token = File.read("./bot_token")

Main.new(token)

