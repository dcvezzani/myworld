# /lib/controllers/api/v1/entities/company.rb

module AwesomeCompany
  module API
    module V1
      module Entities
        class Company < Grape::Entity
          expose :name, documentation: { type: 'String', desc: 'Company Name'}
          expose :address, documentation: { type: 'String', desc: 'Company Address'}
          expose :phone, documentation: { type: 'String', desc: 'Company Phone'}                  
        end
      end
    end
  end
end
