require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@ships = item_defs.find(itemCategoryHashes: 42)

def update_ships
  CSV.open("d2_ships_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    puts 'Fetching Ship data...'
    @ships.each do |ship|
      csv << [
        ship['displayProperties']['name'],
        ship['displayProperties']['description'],
        "https://bungie.net#{ship['displayProperties']['icon']}",
        "https://bungie.net#{ship['screenshot']}"
      ]
    end
  end
end

# @ships.each do |ship|
#   name = ship['displayProperties']['name']
#   next if ship['displayProperties']['name'].include?('/')
#   File.open("ship_imgs/#{name}.jpg", 'wb') do |fo|
#     fo.write open("https://bungie.net#{ship['screenshot']}").read
#   end
# end
