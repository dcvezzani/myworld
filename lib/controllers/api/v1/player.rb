module AwesomeCompany
  module API
    module V1
      class Player < Grape::API
        include Moveable

      	resource :players do

          register_endpoint :move_entity,         "move player in a given direction"
          register_endpoint :say_something_brief, "speak to another player in the same room"
          register_endpoint :say_something,       "speak more intelligently to another player in the same room"
          register_endpoint :check_messages,      "look for messages from other players in the same room"
          register_endpoint :reveal_all_entities, "move player in a given direction"
          
        end
      end
    end
  end
end  
