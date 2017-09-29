require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

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
    # File.open("ghost_imgs/#{ghost['displayProperties']['name']}.jpg", 'wb') do |fo|
    #   fo.write open("https://bungie.net#{ghost['screenshot']}").read
    # end
  end
end
