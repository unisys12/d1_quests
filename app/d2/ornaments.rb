require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

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
