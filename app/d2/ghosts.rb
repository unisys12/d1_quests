require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.manifest.en.DestinyInventoryItemDefinition']

@ghosts = item_defs.find(itemCategoryHashes: 39)

CSV.open('d2_ghosts_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url screenshot_url]
  @ghosts.each do |ghost|
    csv << [
      ghost['displayProperties']['name'],
      ghost['displayProperties']['description'],
      "https://bungie.net#{ghost['displayProperties']['icon']}",
      "https://bungie.net#{ghost['screenshot']}"
    ]
  end
end
