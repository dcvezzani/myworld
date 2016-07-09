module AwesomeCompany
  module Model
    class Room

      include Virtus.model
      include ActiveModel::Serialization
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      # include ActiveModel::Validations

      attribute :name, String
      attribute :color, String
      attribute :items, Array
      attribute :players, Array
      attribute :monsters, Array

      def self.load(attrs)
        redis = (attrs['redis'] or $redis)
        name = attrs[:name]

        p_attrs = JSON::load(redis.hget("players", name))

        Room.new(attrs.merge({redis: redis}))
      end

      def to_json
        attrs = self.attributes.select{|k,v| k != :redis}
        attrs.to_json
      end

      def self.from_json(json)
        attrs = JSON::load(json)

        redis = (attrs['redis'] or $redis)
        name = attrs['name']

        p_attrs = JSON::load(redis.hget("rooms", name))

        Room.new(attrs.merge({redis: redis}))
      end
    end
  end
end

