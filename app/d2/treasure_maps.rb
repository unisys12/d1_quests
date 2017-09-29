require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

map_defs = db['destiny2.en.DestinyObjectiveDefinition']

@maps = map_defs.find("displayProperties.name": /Treasure Map/)

CSV.open('d2_caydes_treasure_maps.csv', 'wb') do |csv|
  csv << %w[name description]
  @maps.each do |map|
    csv << [
      map['displayProperties']['name'],
      map['displayProperties']['description']
    ]
  end
end
