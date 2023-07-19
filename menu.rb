
# обязательная структура CallBack "{menu:bool , href:"table name" }"


class Main

	module Sortmessage

		module Menu
			attr_accessor :link_to, :history_for_back


			def menu(callback_hash = {})

				

				self.link_to = callback_hash["href"] || "start"

				table = callback_hash["table_from"]
				
				case self.link_to
				when "start"

							SendMessage.inline_message  "Чем хочешь заняться?", SendMessage::generate_inline_markup([[
							Inline_Button.button("Учить формулы" , "menu:true, href:sections_physiks")],[
							Inline_Button.button("Решать задачи" , "text:раздел пока в разработке"),
							Inline_Button.button("Посмотреть свою статистику" , "text:раздел пока в разработке")

					]])
				when "formuls" 
					SendMessage.standart_message("Вы выбрали: #{} начинаем учить формулы")

				when "back"
					return(Menu.menu) if table == "sections_physiks"	
					
					SendMessage.inline_message(
						"Какой раздел выбрать?",
						SendMessage::generate_inline_markup(Inline_Button.button_from_bd_for_menu(history_for_back[0])),
						true
					)


				else	
					SendMessage.inline_message(
						"Какой раздел выбрать?",
						SendMessage::generate_inline_markup(Inline_Button.button_from_bd_for_menu(callback_hash)),
						true
					)
				end
			end

			module_function(
				:menu,
				:link_to,
				:link_to=,
				:history_for_back,
				:history_for_back=
			)
		end
	end
end