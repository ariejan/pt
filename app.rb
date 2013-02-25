require 'rubygems'
require 'sinatra'
require 'haml'

require './pivotal'

get '/' do
  haml :index
end
