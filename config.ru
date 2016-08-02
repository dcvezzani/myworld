# config.ru
require 'sinatra'
require 'grape'
require 'grape-entity'
require 'virtus'
require 'active_model'
require 'redis'
require 'byebug'

require './lib/models/basic'
require './lib/models/entity'
require './lib/models/moveable'

require './lib/models/company'
require './lib/models/player'
require './lib/models/monster'
require './lib/models/room'
require './lib/models/high_scores'

require './lib/controllers/api/v1/moveable'
require './lib/controllers/api/v1/companies'
require './lib/controllers/api/v1/player'
require './lib/controllers/api/v1/employees'
require './lib/controllers/api/v1/high_scores'
require './lib/controllers/api/v1/entities/company'
require './lib/controllers/api/v1/base'
require './lib/controllers/api/base'

run AwesomeCompany::API::Base
