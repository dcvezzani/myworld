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

    end
  end
end

