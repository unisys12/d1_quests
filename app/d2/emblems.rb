require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@emblems = item_defs.find(itemCategoryHashes: 19)

CSV.open('d2_emblems_simple.csv', 'wb') do |csv|
  csv << %w[name image_url]
  @emblems.each do |emblem|
    csv << [
      emblem['displayProperties']['name'],
      "https://bungie.net#{emblem['displayProperties']['icon']}"
    ]
    # File.open("emblem_imgs/#{emblem['displayProperties']['name']}.jpg", 'wb') do |fo|
    #   fo.write open("https://bungie.net#{emblem['displayProperties']['icon']}").read
    # end
  end
end
