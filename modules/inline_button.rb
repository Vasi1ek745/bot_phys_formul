# обязательная структура CallBack "{menu:bool , table:table_name ,  name:name, id:id, references:references_id }"

class Main
  # Создает кнопки

  module Sortmessage
      module Inline_Button
        def button(button_text, button_callback)
          
            Telegram::Bot::Types::InlineKeyboardButton.new(text: button_text, callback_data: button_callback)
            
        end
        def button_from_bd_for_menu(callback_hash)
            save_history(callback_hash)
           
            referenses_id = callback_hash["id"]
            table = callback_hash["href"]
            db = Database::setup(table, referenses_id)
            href = next_table(table)
           
            i = 0 
            
            while i < db.size do 
                db[i] = Telegram::Bot::Types::InlineKeyboardButton.new(
                    text: "#{i+1}. #{db[i][1]}",
                    callback_data:("menu:true,table_from:#{table},id:#{db[i][0]},href:#{href}")
                    )
                i+=1
            end
               
            kb = row_two_button(db)

            kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Выбрать все разделы ", callback_data: "all")]
            kb << [Telegram::Bot::Types::InlineKeyboardButton.new(text: "Назад", callback_data: "menu:true,table_from:#{table},href:back")]
            
            
            kb
        end

        def row_two_button(db)
              i = 0
              kb = []
            while i < db.size 
                kb << [db[i], db[i+1]].compact 
                i+=2
            end 
            kb
        end

        def save_history(kb)
            Menu.history_for_back ||= []
            Menu.history_for_back << kb

        end

        def next_table(table)
           tabels = ["sections_physiks","topics","thems","formuls"]
            tabels[tabels.index(table) + 1]
        end
        def previous_table(table)
            tabels = ["sections_physiks","topics","thems","formuls"]
            tabels[tabels.index(table) -1]
        end

       module_function(
            :button,
            :button_from_bd_for_menu,
            :next_table,
            :previous_table,
            :save_history,
            :row_two_button
            ) 
       end
  end
end