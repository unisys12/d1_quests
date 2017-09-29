require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'
# require "open-uri"

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.en.DestinyInventoryItemDefinition']

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
