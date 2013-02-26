require 'rubygems'
require 'sinatra'
require 'haml'

require './pivotal'

DB = Sequel.connect(ENV['DATABASE_URL'])

get '/' do
  metrics = DB[:metrics]

  @latest_iteration = metrics.max(:iteration)
  @data = metrics.where(:iteration => @latest_iteration).reverse_order(:created_at)

  haml :index
end
