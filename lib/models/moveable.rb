module AwesomeCompany
  module Model
    module Moveable

      def self.included(base)
        base.extend(ClassMethods)

        base.instance_eval do
          attribute :x, Integer
          attribute :y, Integer

          after_load :init_geoloc
        end
      end

      def init_geoloc(attrs)
        unless(attrs.keys.include?(:x) and attrs.keys.include?(:y))
          name = attrs[:name]

          p_attrs = JSON::load(self.entity_name(name))
          self.x = p_attrs['x']
          self.y = p_attrs['y']
        end
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

        # room: remove entity from old_position
        old_room = Room.from_json(redis.hget("rooms", old_position))
        old_room[redis_key].delete(name)
        redis.hset("rooms", old_position, old_room.to_json)
        
        # room: add entity to new_position
        new_room = Room.from_json(redis.hget("rooms", new_position))
        new_room[redis_key] << name
        redis.hset("rooms", new_position, new_room.to_json)

        # entity: update position
        entity= self.class.from_json(redis.hget(redis_key, name))
        entity['x'] = self.x
        entity['y'] = self.y
        redis.hset(redis_key, name, entity.to_json)
      end

      module ClassMethods
      end
    end
  end
end


