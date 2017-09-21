require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.manifest.en.DestinyInventoryItemDefinition']

@emblems = item_defs.find(itemCategoryHashes: 19)

CSV.open('d2_emblems_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url]
  @emblems.each do |emblem|
    csv << [
      emblem['displayProperties']['name'],
      emblem['displayProperties']['description'],
      "https://bungie.net#{emblem['displayProperties']['icon']}"
    ]
  end
end
