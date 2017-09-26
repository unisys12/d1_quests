require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

map_defs = client['destiny2.en.DestinyObjectiveDefinition']

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
