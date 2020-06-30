ENV['SINATRA_ENV'] ||= "development"

require 'pry'
require 'open-uri'
require 'net/http'
require 'json'
require 'addressable/uri'
require 'nokogiri'
require 'sinatra/flash'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'dotenv/load' if ENV['SINATRA_ENV'] == 'development'

# ActiveRecord::Base.establish_connection(
#   :adapter => "sqlite3",
#   :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
# )

ActiveRecord::Base.time_zone_aware_attributes = [:datetime]

set :database_file, "./database.yml"

require './app/controllers/application_controller'
require_all 'app'
