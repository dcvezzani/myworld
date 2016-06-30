# /lib/controllers/api/v1/base.rb

module AwesomeCompany
  module API
    module V1
      class Base < Grape::API
        mount AwesomeCompany::API::V1::Companies      
        mount AwesomeCompany::API::V1::Employees              
      end
    end
  end
end  
