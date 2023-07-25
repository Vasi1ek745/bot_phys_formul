class Main

	module Sortmessage

		module Menu

			# вывод кнопок меню
			# переменная current_state нужна что бы хранить текущее состояние меню
			# current_state это хэш следующего вида {position:"position",:current_id:"current_id", previous_position:"previous_position",previous_id: id } 
			# переменая history_state храни массив со всеми состояниями
			# в кнопках обязательно callback в слудующем формате "link_to:link_to, id:id"

			attr_accessor :current_state, :history_state

			def menu

				Menu.initialize	# инициализируем current_state и history_state если еще не созданы
				
				p Menu.current_state
				case Menu.current_state[:position]
				when "start_menu"

					buttons = Inline_Button.start_menu_buttons # кнопки для начального меню
					kb = Inline_Button.buttons(buttons)					
					SendMessage.inline_message("Чем хочешь заняться?", SendMessage::generate_inline_markup(kb))

				when "sections"
					# извлекаем данные из БД 
					data = Database::data_from_table_for_button(Menu.current_state) 
				    # обрабатываем кнопки до нужного формата
				    buttons = Inline_Button.data_format_to_button(data, "topics")
				    kb = Inline_Button.buttons(buttons)

				    SendMessage.inline_message("Какой раздел хочешь выбрать?", SendMessage::generate_inline_markup(kb), true)

				when "topics"

					# извлекаем данные из БД 
					data = Database::data_from_table_for_button(Menu.current_state) 
				    # обрабатываем кнопки до нужного формата
				    buttons = Inline_Button.data_format_to_button(data, "thems")
				    kb = Inline_Button.buttons(buttons)

				    SendMessage.inline_message("Какой раздел хочешь выбрать?", SendMessage::generate_inline_markup(kb), true)
				
				when "thems"

					# когда дошли до определенной темы 
					user_choice = Database::user_choice_thems(Menu.current_state)
					SendMessage.standart_message("Вы выбрали: \n - #{user_choice}.\nНачинаем изучение формул. Для остановки отправьте /stop или вернитесь в /menu")
					Learn.start_learn(user_choice)

				when "back"
					# возвращаемся на два состояния назад, что бы попсть в предыдущий раздел
					Menu.change_current_state_for_back
					Menu.menu					
				
				when "all"
					# когда  выбрли все разделы в каком-то окне

					if Menu.current_state[:previous_position] == "topics"
						user_choice = Database::user_choice_topics_with_section_id(Menu.current_state)

					else
						user_choice = Database::user_choice_all(Menu.current_state)
					end
						user_choice_list = "\n"
						user_choice.each {|x| user_choice_list+= " - " + x + "\n"}
					SendMessage.standart_message("Вы выбрали:"+ user_choice_list+ "\nНачинаем изучение формул. Для остановки отправьте /stop или вернитесь в /menu")
					Learn.start_learn(user_choice)

				end	
			end
			def initialize
				Menu.current_state ||= {position:"start_menu",current_id:nil, previous_position:nil , previous_id: nil}
				Menu.history_state ||= []
				Menu.history_state << Menu.current_state.values
				p "test"
			end
			def change_current_state_for_back
				self.history_state = self.history_state.uniq[0..-3]
				self.current_state[:position] = self.history_state[-1][0]
				self.current_state[:current_id] = self.history_state[-1][1]
				self.current_state[:previous_position] = self.history_state[-1][2]
				self.current_state[:previous_id] = self.history_state[-1][3]
			end

			module_function(
				 :menu,
				 :current_state,
				 :current_state=,
				 :history_state,
				 :history_state=,
				 :initialize,
				 :change_current_state_for_back
			)

		end
	end
end