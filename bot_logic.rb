require "./bot_logic/learn"
require "./bot_logic/menu"


class BotLogic
	def initialize 
		Learn.learn_status = nil
		Menu.current_state = nil
		Menu.history_state = nil
	end
end