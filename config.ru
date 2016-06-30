# config.ru
require 'sinatra'
require 'grape'
require 'grape-entity'

require_relative 'lib/controllers/api/v1/companies'
require_relative 'lib/controllers/api/v1/employees'
require_relative 'lib/controllers/api/v1/entities/company'
require_relative 'lib/controllers/api/v1/base'
require_relative 'lib/controllers/api/base'

run AwesomeCompany::API
