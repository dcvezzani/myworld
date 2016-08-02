module AwesomeCompany
  module API
    module V1
      class Player < Grape::API
        GEntity = AwesomeCompany::Model::Monster
        include Moveable

      	resource :monsters do

          register_endpoint :move_entity,         "move monster in a given direction"
          register_endpoint :say_something_brief, "speak to another entity in the same room"
          register_endpoint :say_something,       "speak more intelligently to another entity in the same room"
          register_endpoint :check_messages,      "look for messages from other entities in the same room"
          register_endpoint :reveal_all_entities, "move monster in a given direction"
          
        end
        
      end
    end
  end
end  
