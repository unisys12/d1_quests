require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'
require "open-uri"

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.en.DestinyInventoryItemDefinition']

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
    File.open("sparrow_imgs/#{sparrow['displayProperties']['name']}.jpg", 'wb') do |fo|
      fo.write open("https://bungie.net#{sparrow['screenshot']}").read
    end
  end
end
