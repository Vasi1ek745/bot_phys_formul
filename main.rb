require 'telegram/bot'
require './modules/checkmessage'
require './modules/callbackmessage'
require './db/database'
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

      Database.initialize
      
      @token = token

      Telegram::Bot::Client.run(@token) do |bot|

        # время запуска для проверки сообщений старое или новое
        start_bot_time = Time.now.to_i

          bot.listen do |message|
              # Thread.start(message) do |message|
              
                Database.check_user(message.from) if CheckMessage.message_is_new(start_bot_time,message)
                Sortmessage.sort_new_message(message, bot, message.from.id) if CheckMessage.message_is_new(start_bot_time,message)
              # end
          end
        end
      end


end

# loop do
#   begin
  token = File.read("./bot_token")
  BotLogic.new
  Main.new(token)
#   rescue StandardError => e
#     p e
#   end
# end

