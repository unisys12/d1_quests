require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'
require "open-uri"

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.en.DestinyInventoryItemDefinition']

@ornaments = item_defs.find(itemCategoryHashes: 56)

CSV.open('d2_ornaments_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url]
  @ornaments.each do |ornament|
    next unless ornament['itemTypeDisplayName'].index(/Ornament/i)
    csv << [
      ornament['displayProperties']['name'],
      ornament['displayProperties']['description'],
      "https://bungie.net#{ornament['displayProperties']['icon']}"
    ]
    File.open("ornament_imgs/#{ornament['displayProperties']['name']}.jpg", 'wb') do |fo|
      fo.write open("https://bungie.net#{ornament['displayProperties']['icon']}").read
    end
  end
end
