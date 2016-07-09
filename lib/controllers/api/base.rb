# /lib/controllers/api/base.rb

module AwesomeCompany
  module API
    class Base < Grape::API
      #set :bind, '0.0.0.0'

      format :json # define the format
      mount AwesomeCompany::API::V1::Base
    end
  end
end

