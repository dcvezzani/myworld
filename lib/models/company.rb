module AwesomeCompany
  module Model
    class Company

      include Virtus.model
      include ActiveModel::Serialization
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      # include ActiveModel::Validations

      attribute :name, String
      attribute :phone, String
      attribute :address, String
    end
  end
end

