# config.ru
require 'sinatra'
require 'grape'
require 'grape-entity'
require 'virtus'
require 'active_model'

require './lib/models/company'
require './lib/controllers/api/v1/companies'
require './lib/controllers/api/v1/employees'
require './lib/controllers/api/v1/entities/company'
require './lib/controllers/api/v1/base'
require './lib/controllers/api/base'

run AwesomeCompany::API::Base
