class Main
  module Sortmessage
    #  кнопки для меню
      module Inline_Button

        def buttons(buttons)

            kb = create_buttons(buttons) # создаем кнопки для вывода
            kb = row_two_buttons(kb)    # разбиваем кнопки на 2 в ряд
            # добавляем кнопки назад и выбрать все, если находимся не в первом меню                          
            kb = add_button_back_and_all(kb) if BotLogic::Menu.current_state[:position] != "start_menu" 
            kb
        end

        def create_buttons(buttons)
            kb = []
            buttons.each { |button| kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: button[:text], callback_data: button[:callback])}
            kb
        end

        def row_two_buttons(kb)
            row_two_buttons = []
            i = 0
            while i < kb.size 
                row_two_buttons << [kb[i], kb[i+1]].compact 
                i+=2
            end 
          row_two_buttons
        end

        def add_button_back_and_all(kb)
           kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Выбрать все разделы", callback_data: "link_to:all, id:")]
           kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Назад", callback_data: "link_to:back, id:")]
           kb
        end

        # в кнопках обязательно callback в следующем формате "link_to:link_to,id:id"
        def data_format_to_button(data, next_table)
          buttons = []
          data.each {|x| buttons << {text: x[0], callback:"link_to:#{next_table}, id:#{x[1]}"} }           
          buttons
        end

        def start_menu_buttons
            # кнопки для начального меню каждая кнопка имеет формат {text:"text", callback:"callback"}
            buttons = [
                {text:"Учить формулы", callback:"link_to:sections, id:"}, 
                {text:"Решать задачи",callback:"link_to:solve_problems, id:"},
                {text:"Посмотреть свою статистику",callback:"link_to:solve_problems, id:"}
            ]
        end
 
        module_function :buttons, :row_two_buttons, :data_format_to_button, :create_buttons, :add_button_back_and_all, :start_menu_buttons


       end
  end
end