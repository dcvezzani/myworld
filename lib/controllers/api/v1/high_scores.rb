module AwesomeCompany
  module API
    module V1
      class HighScores < Grape::API
      	resource :high_scores do

          # show scores for all players
          #
      	  desc "show scores for all players"
      	  get do
            player_names = $redis.hkeys("players")
            hs = AwesomeCompany::Model::HighScores.load({redis: $redis, player_names: player_names})
            hs.for_all_players.to_json
      	  end

          # add point for player
          #
      	  desc "add point for player"
          params do
            requires :player_name, type: String, desc: "player's name"
          end
      	  post '/add_point_for/:player_name' do
      	  	player_name = params[:player_name]
            
            player_names = $redis.hkeys("players")
            hs = AwesomeCompany::Model::HighScores.load({redis: $redis, player_names: player_names})
            hs.add_point_for_player!(player_name).to_json
      	  end

          # reset player scores
          #
      	  desc "reset player scores"
      	  post '/reset' do
            player_names = $redis.hkeys("players")
            hs = AwesomeCompany::Model::HighScores.load({redis: $redis, player_names: player_names})
            hs.reset_all!
      	  end

        end
      end
    end
  end
end  
