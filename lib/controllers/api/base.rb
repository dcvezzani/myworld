# /lib/controllers/api/base.rb

module AwesomeCompany
  module API
    class Base < Grape::API
      format :json # define the format
      mount AwesomeCompany::API::V1::Base
    end
  end
end

