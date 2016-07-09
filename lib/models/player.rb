module AwesomeCompany
  module Model
    class Player

      include Virtus.model
      include ActiveModel::Serialization
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      # include ActiveModel::Validations

      attribute :name, String
      attribute :x, Integer
      attribute :y, Integer
      attribute :redis, Object

      def self.load(attrs)
        redis = attrs[:redis]
        name = attrs[:name]

        p_attrs = JSON::load(redis.hget("players", name))
        x = p_attrs['x']
        y = p_attrs['y']

        Player.new(attrs.merge({x: x, y: y}))
      end

      def move(direction)
        old_position = "#{self.x},#{self.y}"

        direction = direction.slice(0,1).downcase
        if(%w{n s e w}.include?(direction))
          case direction
          when 'n'
            unless(self.y == 0)
              self.y -= 1
            end

          when 's'
            unless(self.y == 2)
              self.y += 1
            end

          when 'e'
            unless(self.x == 2)
              self.x += 1
            end

          when 'w'
            unless(self.x == 0)
              self.x -= 1
            end
          end
        end

        new_position = "#{self.x},#{self.y}"

        # room: remove player from old_position
        old_room = JSON::load(redis.hget("rooms", old_position))
        old_room['players'].delete(name)
        redis.hset("rooms", old_position, old_room.to_json)
        
        # room: add player to new_position
        new_room = JSON::load(redis.hget("rooms", new_position))
        new_room['players'] << name
        redis.hset("rooms", new_position, new_room.to_json)

        # player: update position
        player = JSON::load(redis.hget("players", name))
        player['x'] = self.x
        player['y'] = self.y
        redis.hset("players", name, player.to_json)
      end
    end
  end
end

