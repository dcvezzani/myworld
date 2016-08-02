module AwesomeCompany
  module Model
    class Monster
      include Basic
      include Entity
      include Moveable

      resource :monsters
    end
  end
end

