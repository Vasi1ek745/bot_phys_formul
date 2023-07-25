
class Main

	module Sortmessage

		module Menu

			# вывод кнопок меню, с помощью кнопок делем выборку тем для пользователя
			# переменная current_state нужна что бы хранить текущее состояние меню
			# current_state это хэш следующего вида {position:"position",:current_id:"current_id", previous_position:"previous_position",previous_id: id } 
			# переменая history_state храни массив со всеми состояниями
			# в кнопках обязательно callback в слудующем формате "link_to:link_to, id:id"

			attr_accessor :current_state, :history_state

			def menu

				# инициализируем current_state и history_state если еще не созданы

				self.current_state ||= {position:"start_menu",current_id:nil, previous_position:nil , previous_id: nil}
				self.history_state ||= []
				self.history_state << self.current_state.values
				

				if current_state[:position] == "start_menu"
			
					# кнопки для начального меню каждая кнопка имеет формат {text:"text", callback:"callback"}
					buttons = [
						{text:"Учить формулы", callback:"link_to:sections, id:"}, 
						{text:"Решать задачи",callback:"link_to:solve_problems, id:"},
						{text:"Посмотреть свою статистику",callback:"statistics"}
					]

					kb = Inline_Button.buttons(buttons)
					
					SendMessage.inline_message("Чем хочешь заняться?", SendMessage::generate_inline_markup(kb))

				elsif current_state[:position] == "sections" || current_state[:position] == "topics" 
				
					# кнопки для разделов название берем из для каждого раздела

					data = Database::data_from_table_for_button(self.current_state)
				    # обрабатываем кнопки до нужного формата
				    next_table = Database::next_table(current_state[:position])
				    buttons = Inline_Button.data_format_to_button(data, next_table)
				    kb = Inline_Button.buttons(buttons)

				    SendMessage.inline_message("Какой раздел хочешь выбрать?", SendMessage::generate_inline_markup(kb), true)

				elsif current_state[:position] == "back"
					# кнопка назад
					# удаляем два последних состояния и вызываем меню с последним состоянием

					self.history_state = self.history_state.uniq[0..-3]

					self.current_state[:position] = self.history_state[-1][0]
					self.current_state[:current_id] = self.history_state[-1][1]
					self.current_state[:previous_position] = self.history_state[-1][2]
					self.current_state[:previous_id] = self.history_state[-1][3]

					Menu.menu	

				elsif current_state[:position] == "thems"
					# когда дошли до определенной темы 
					user_choice = Database::user_choice_thems(self.current_state)
					SendMessage.standart_message("Вы выбрали: \n - #{user_choice}.\nНачинаем изучение формул. Для остановки отправьте /stop или вернитесь в /menu")

					Learn.start_learn(user_choice)

				elsif current_state[:position] == "all"
					# когда  выбрли все разделы в каком то окне

					if current_state[:previous_position] == "topics"
						user_choice = Database::user_choice_topics_with_section_id(self.current_state)

					else 
						user_choice = Database::user_choice_all(current_state)
					end

						user_choice_list = "\n"
						user_choice.each {|x| user_choice_list+= " - " + x + "\n"}
					SendMessage.standart_message("Вы выбрали:"+ user_choice_list+ " \nНачинаем изучение формул. Для остановки отправьте /stop или вернитесь в /menu")
					Learn.start_learn(user_choice)
			
				end

			end

			module_function(
				 :menu,
				 :current_state,
				 :current_state=,
				 :history_state,
				 :history_state=
			)

		end
	end
end