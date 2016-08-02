# /lib/controllers/api/v1/base.rb

module AwesomeCompany
  module API
    module V1
      class Base < Grape::API
        prefix 'api/v1' # set the url prefix
        mount AwesomeCompany::API::V1::Moveable      
        mount AwesomeCompany::API::V1::Companies      
        mount AwesomeCompany::API::V1::Employees              
        mount AwesomeCompany::API::V1::Player              
        mount AwesomeCompany::API::V1::HighScores              

        Room = ::AwesomeCompany::Model::Room
        Player = ::AwesomeCompany::Model::Player
        Monster = ::AwesomeCompany::Model::Monster

        def self.xstart_world
          while(true) do
            check_input
            apply_events
            render_world
            sleep(0.2)
          end
        end

        def self.start_world
          $redis = Redis.new(:host => "localhost", :port => 6379, :db => "myworld")

          unless $redis.hlen("players") > 0
            $redis.hset("players", "dave", Player.new({name: :dave, x: 1, y: 1}).to_json)
            $redis.hset("players", "jalen", Player.new({name: :jalen, x: 2, y: 2}).to_json)
          end
          
          unless $redis.hlen("monsters") > 0
            $redis.hset("monsters", "minotaur", Monster.new({name: :minotaur, x: 0, y: 0}).to_json)
            $redis.hset("monsters", "cyclops", Monster.new({name: :cyclops, x: 0, y: 0}).to_json)
          end
          
          unless $redis.hlen("rooms") == 9
            $redis.hset("rooms", "0,0", Room.new({name: :red, color: :red, items: [], players: [], monsters: %w{minotaur cyclops}}).to_json)
            $redis.hset("rooms", "0,1", Room.new({name: :rainbow, color: :rainbow, items: [], players: []}).to_json)
            $redis.hset("rooms", "0,2", Room.new({name: :green, color: :green, items: [], players: []}).to_json)
            $redis.hset("rooms", "1,0", Room.new({name: :blue, color: :blue, items: [], players: []}).to_json)
            $redis.hset("rooms", "1,1", Room.new({name: :yellow, color: :yellow, items: [], players: %w{dave}}).to_json)
            $redis.hset("rooms", "1,2", Room.new({name: :violet, color: :violet, items: [], players: []}).to_json)
            $redis.hset("rooms", "2,0", Room.new({name: :white, color: :white, items: [], players: []}).to_json)
            $redis.hset("rooms", "2,1", Room.new({name: :black, color: :black, items: [], players: []}).to_json)
            $redis.hset("rooms", "2,2", Room.new({name: :orange, color: :orange, items: [], players: %w{jalen}}).to_json)
          end

        end

        def self.check_input
        end

        def self.apply_events
        end

        def self.render_world
          puts Time.now.strftime("%H%M%S")
        end
      end

      Base.start_world
    end
  end
end  
