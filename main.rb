require 'telegram/bot'
require './modules/checkmessage'
require './modules/callbackmessage'
require './modules/database'
require './modules/sendmessage'
require './modules/sortmessage'
require './modules/standartmessage'
require './modules/inline_button.rb'
require './bot_logic/menu.rb'
require './bot_logic/learn.rb'
require 'byebug'
require 'pry'



# основной класс, запуск

class Main

  def initialize(token)
      
      @token = token

      Telegram::Bot::Client.run(@token) do |bot|

        # время запуска для проверки сообщений старое или новое
        start_bot_time = Time.now.to_i

          bot.listen do |message|
          Sortmessage.sort_new_message(message, bot) if CheckMessage.message_is_new(start_bot_time,message)
          end
        end
      end


end

token = File.read("./bot_token")

Main.new(token)

