class Main
  module Sortmessage
    #  модуль для создания кнопок telegram
      module Inline_Button

          def buttons(buttons)

            kb = [] 
            # создаем кнопки для вывода
            buttons.each do |button|
             kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: button[:text], callback_data: button[:callback])
            end
            # что бы кнопки выводились столбиком по 2 вызываем функцию row_two_button, разобьет исходный массив на двумерный массив [[,],[,]]
             kb = row_two_buttons(kb)

             # добавляем кнопки назад и выбрать все если находимся не в первом меню
            if Menu.current_state[:position] != "start_menu"
               kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Выбрать все разделы", callback_data: "link_to:all, id:")]
               kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Назад", callback_data: "link_to:back, id:")]
            end

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

          def data_format_to_button(data, next_table)
            buttons = []

            data.each {|x| buttons << {text: x[0], callback:"link_to:#{next_table}, id:#{x[1]}"} }

           

            buttons


          end
 
          module_function :buttons, :row_two_buttons, :data_format_to_button


       end
  end
end