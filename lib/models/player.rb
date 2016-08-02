module AwesomeCompany
  module Model
    class Player
      include Basic
      include Entity
      include Moveable

      resource :players
    end
  end
end

