module AwesomeCompany
  module API
    module V1
      module Moveable
        def self.included(base)
          base.extend(ClassMethods)

          base.instance_eval do
          end
        end
        
        module ClassMethods
          def register_endpoint(label, desc)
            send(label, desc)
          end

          def move_entity(options = {})
            options.reverse_merge!({
              description: "move entity to room in a given direction", 
              who: "player's name", 
              direction: "n/w/s/e"
            })

            desc options[:description]
            params do
              #requires :direction_info, type: Hash, desc: "e.g., {'name': 'dave', 'direction': 'w'}"
              requires :who, type: String, desc: options[:who]
              requires :direction, type: String, desc: options[:direction]
            end
            get '/:who/move/:direction' do
              direction = params[:direction]
              who = params[:who]

              p = AwesomeCompany::Model::GEntity.load({redis: $redis, name: who})
              p.move(direction)

              #present :company, companies, with: AwesomeCompany::API::V1::Entities::Company
              p.redis = nil
              p.to_json
            end
          end
          
          def say_something_brief(options = {})
            options.reverse_merge!({
              description: "speak to another player in the same room", 
              me: "player's name", 
              other: "other player's name", 
              message: "what you want to say"
            })

            desc options[:description]
            params do
              #requires :direction_info, type: Hash, desc: "e.g., {'name': 'dave', 'direction': 'w'}"
              requires :me, type: String, desc: options[:me]
              requires :other, type: String, desc: options[:other]
              requires :message, type: String, desc: options[:message]
            end
            get '/:me/speaks-to/:other/and-says/:message' do
              my_name = params[:me]
              other_name = params[:other]
              message = params[:message]

              me = GEntity.from_json($redis.hget("players", my_name))
              current_room = AwesomeCompany::Model::Room.from_json($redis.hget("rooms", "#{me[:x]},#{me[:y]}"))

              if current_room[:players].include?(other_name)
                $redis.lpush("messages.#{other_name}", {"recipient_name" => my_name, "message" => message}.to_json)
              else
                error! "#{other_name} is not in the same room with you", 404
              end

              {"action" => "message sent", "details" => "from #{other_name} to #{my_name}: #{message}"}.to_json
            end
          end

          def say_something(options = {description: "speak more intelligently to another entity in the same room"})
            desc options[:description]

            options.reverse_merge!({
              description: "speak more intelligently to another entity in the same room", 
              me: "player's name", 
              other: "other player's name", 
              message: "what you want to say"
            })
            
            params do
              #requires :direction_info, type: Hash, desc: "e.g., {'name': 'dave', 'direction': 'w'}"
              requires :me, type: String, desc: "player's name"
              requires :other, type: String, desc: "other player's name"
              requires :message, type: String, desc: "what you want to say"
            end
            post '/:me/speaks-to/:other' do
              my_name = params[:me]
              other_name = params[:other]
              message = params[:message]

              me = GEntity.from_json($redis.hget("players", my_name))
              current_room = AwesomeCompany::Model::Room.from_json($redis.hget("rooms", "#{me[:x]},#{me[:y]}"))

              if current_room[:players].include?(other_name)
                $redis.lpush("messages.#{other_name}", {"recipient_name" => my_name, "message" => message}.to_json)
              else
                error! "#{other_name} is not in the same room with you", 404
              end

              {"action" => "message sent", "details" => "from #{other_name} to #{my_name}: #{message}"}.to_json
            end
      	  end

          def check_messages(options = {description: "look for messages from other entities in the same room"})
            desc options[:description]
            params do
              #requires :direction_info, type: Hash, desc: "e.g., {'name': 'dave', 'direction': 'w'}"
              requires :me, type: String, desc: "player's name"
            end
            get '/:me/messages' do
              my_name = params[:me]

              me = GEntity.from_json($redis.hget("players", my_name))
              current_room = AwesomeCompany::Model::Room.from_json($redis.hget("rooms", "#{me[:x]},#{me[:y]}"))

              msg_size = $redis.llen("messages.#{my_name}")
              messages = {}
              if msg_size > 0
                (0..msg_size).each do
                  msg_data = $redis.rpop("messages.#{my_name}")
                  next if msg_data.nil?

                  msg = JSON::load(msg_data)
                  other_name = msg['recipient_name']
                  message = msg['message']

                  messages[other_name] = [] if messages[other_name].nil?
                  messages[other_name] << message
                end

              else
                error! "no messages are waiting for you", 404
              end

              {"action" => "messages received", "messages" => messages}.to_json 
            end
      	  end

          def reveal_all_entities(options = {description: "see where everyone is"})
            desc options[:description]
            get '/whereall' do

              rooms = ['0,0', '0,1', '0,2', '1,0', '1,1', '1,2', '2,0', '2,1', '2,2'].inject({}) do |h, room_id|
                room_details = JSON::load($redis.hget("rooms", room_id))
                h.merge!(room_id => room_details['players'] + room_details['monsters'])
              end

              rooms.to_json
            end
      	  end

        end
          
      end
    end
  end
end  
