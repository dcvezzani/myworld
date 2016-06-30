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
      	  	companies = if params[:name]
      	  	  #Company.where(name: params[:name])
              [AwesomeCompany::Model::Company.new({ name: 'Nigerian Royalty Incorporated', phone: '555-555', address: '55 Nigeria, Nigeria St, Nigeria' })].first

      	  	else
      	  	  #Company.all
              [AwesomeCompany::Model::Company.new({ name: 'Nigerian Royalty Incorporated', phone: '555-555', address: '55 Nigeria, Nigeria St, Nigeria' }), AwesomeCompany::Model::Company.new({ name: 'Hungarian Royalty Incorporated', phone: '333-333', address: '55 Hungary, Hungary St, Hungary' })]
      	  	end  

      	    present :company, companies, with: AwesomeCompany::API::V1::Entities::Company
      	  end

      	  # get do
      	  # 	companies = CompanyQuery.new(params)
      	  # 	present :company, companies, with: AwesomeCompany::API::V1::Entities::Company
          # # -> { company: { name: 'Nigerian Royalty Incorporated', phone: '555-555', address: '55 Nigeria, Nigeria St, Nigeria' } }            
      	  # end
          
      	end
      end
    end
  end
end  

