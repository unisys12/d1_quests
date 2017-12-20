require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@sparrows = item_defs.find(itemCategoryHashes: 43)

def update_sparrows
  CSV.open("d2_sparrows_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    puts 'Fetching Sparrow data...'
    @sparrows.each do |sparrow|
      csv << [
        sparrow['displayProperties']['name'],
        sparrow['displayProperties']['description'],
        "https://bungie.net#{sparrow['displayProperties']['icon']}",
        "https://bungie.net#{sparrow['screenshot']}"
      ]
      # File.open("sparrow_imgs/#{sparrow['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{sparrow['screenshot']}").read
      # end
    end
  end
end
