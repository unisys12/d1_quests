require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.manifest.en.DestinyInventoryItemDefinition']

@sparrows = item_defs.find(itemCategoryHashes: 43)

CSV.open('d2_sparrows_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url screenshot_url]
  @sparrows.each do |sparrow|
    csv << [
      sparrow['displayProperties']['name'],
      sparrow['displayProperties']['description'],
      "https://bungie.net#{sparrow['displayProperties']['icon']}",
      "https://bungie.net#{sparrow['screenshot']}"
    ]
  end
end
