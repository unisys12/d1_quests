require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

map_defs = db['destiny2.en.DestinyObjectiveDefinition']

@maps = map_defs.find("displayProperties.name": /Treasure Map/)

def update_treasure_maps
  CSV.open("d2_caydes_treasure_maps_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name description]
    puts 'Fetching Treasure Maps...'
    @maps.each do |map|
      csv << [
        map['displayProperties']['name'],
        map['displayProperties']['description']
      ]
    end
  end
end
