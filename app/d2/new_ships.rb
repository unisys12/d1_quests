require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@ships = item_defs.find(itemCategoryHashes: 42)

CSV.foreach('d2_ships_simple.csv') do |row|
  CSV.open('new_ships.csv', 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    @ships.each do |ship|
      next if row[0] == ship['displayProperties']['name']
      csv << [
        ship['displayProperties']['name'],
        ship['displayProperties']['description'],
        "https://bungie.net#{ship['displayProperties']['icon']}",
        "https://bungie.net#{ship['screenshot']}"
      ]
    end
  end
end
