require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.manifest.en.DestinyInventoryItemDefinition']

@ships = item_defs.find(itemCategoryHashes: 42)

CSV.open('d2_ships_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url screenshot_url]
  @ships.each do |ship|
    csv << [
      ship['displayProperties']['name'],
      ship['displayProperties']['description'],
      "https://bungie.net#{ship['displayProperties']['icon']}",
      "https://bungie.net#{ship['screenshot']}"
    ]
  end
end
