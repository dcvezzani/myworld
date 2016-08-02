module AwesomeCompany
  module Model
    class HighScores

      include Virtus.model
      include ActiveModel::Serialization
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      # include ActiveModel::Validations

      attribute :high_scores, Hash[String => Integer]
      attribute :player_names, Array
      attribute :redis, Object

      def self.load(attrs)
        redis = attrs[:redis]
        high_scores = attrs[:high_scores]
        player_names = attrs[:player_names]

        hs = HighScores.new(attrs.merge({redis: redis}))

        if high_scores.nil?
          hs.load
        else
          high_scores.each do |player_name, player_score|
            hs.high_scores[player_name] = player_score
          end
          hs.save
        end
        hs
      end

      def player_score(player_name)
        redis.hget("high_scores", player_name)
      end

      def player_names
        redis.hkeys("high_scores")
      end

      def load
        player_names.each do |player_name|
          player_score = redis.hget("high_scores", player_name)
          high_scores[player_name] = player_score
        end
      end
      
      def save
        high_scores.each do |player_name, player_score|
          redis.hset("high_scores", player_name, player_score)
        end
      end

      def to_json
        attrs = self.attributes.select{|k,v| k != :redis}
        attrs.to_json
      end

      def self.from_json(json)
        attrs = JSON::load(json)
        load(attrs)
      end

      def add_point_for_player!(player_name)
        player_score = (player_score(player_name) or 0)
        player_score = player_score.to_i + 1
        high_scores[player_name] = player_score
        save
      end

      def reset_all!(player_names = self.player_names)
        player_names.each do |player_name|
          high_scores[player_name] = 0
        end
        save
      end

      def for_all_players
        player_scores = {}
        player_names.each do |player_name|
          player_scores[player_name] = player_score(player_name)
        end
        player_scores
      end

    end
  end
end

