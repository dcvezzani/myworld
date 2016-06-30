# /lib/controllers/api/v1/companies.rb

module AwesomeCompany
  module API
    module V1
      class Companies < Grape::API
      	params do
      	  optional :name, type: String, desc: 'Company name you wish to filter on'
      	end
      	resource :companies do
      	  desc "Retrieve a list of Companies"
      	  get do
      	  	if params[:name]
      	  	  Company.where(name: params[:name])
      	  	else
      	  	  Company.all
      	  	end  
      	  end
      	end
      end
    end
  end
end  

