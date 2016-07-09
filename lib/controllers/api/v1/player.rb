module AwesomeCompany
  module API
    module V1
      class Player < Grape::API
      	resource :player do
      	  desc "move player in a given direction"
          params do
            #requires :direction_info, type: Hash, desc: "e.g., {'name': 'dave', 'direction': 'w'}"
            requires :who, type: String, desc: "player's name"
            requires :direction, type: String, desc: "n/w/s/e"
          end
      	  get '/:who/move/:direction' do
      	  	direction = params[:direction]
      	  	who = params[:who]

            p = AwesomeCompany::Model::Player.load({redis: $redis, name: who})
            p.move(direction)

      	    #present :company, companies, with: AwesomeCompany::API::V1::Entities::Company
            p.redis = nil
            p.to_json
      	  end

      	  desc "see where everyone is"
      	  get '/whereall' do

            rooms = ['0,0', '0,1', '0,2', '1,0', '1,1', '1,2', '2,0', '2,1', '2,2'].inject({}) do |h, room_id|
              room_details = JSON::load($redis.hget("rooms", room_id))
              h.merge!(room_id => room_details['players'])
            end

            rooms.to_json
      	  end
          
        end
      end
    end
  end
end  
