require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
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

def compare
  old = CSV.table('d2_ships_simple_12_12.csv')
  update = CSV.table("d2_ships_simple_#{Date.today}.csv")
 
  if update == old
    puts 'No new items found...'
    exit
  else
    puts 'new items listed...'
    new_hash = update.to_a - old.to_a
    puts "#{new_hash.count} new Ships in the this update..."
    new_hash.flatten
  end
 
  CSV.open("d2_new_Ghosts_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    new_hash.each do |items|
      csv << [
        items[0],
        items[1],
        items[2],
        items[3]
      ]
    end
  end
end

compare


# @ships.each do |ship|
#   name = ship['displayProperties']['name']
#   next if ship['displayProperties']['name'].include?('/')
#   File.open("ship_imgs/#{name}.jpg", 'wb') do |fo|
#     fo.write open("https://bungie.net#{ship['screenshot']}").read
#   end
# end
