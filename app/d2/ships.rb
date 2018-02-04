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

# def write_new(updates)
#   puts "Writing file containing #{updates.count} new Ships from this update..."
#   CSV.open("d2_new_Ships_#{Date.today}.csv", 'wb') do |csv|
#     csv << %w[name flavor_text image_url screenshot_url]
#     updates.each do |update|
#       csv << update
#     end
#   end
# end

# def compare_ships
#   arr_updates = []
#   puts 'Comparing Ships...'
#   old = File.open('d2_ships_simple_2018-01-16.csv')
#   update = File.open("d2_ships_simple_#{Date.today}.csv")

#   arr_a = []

#   old_lines = old.readlines
#   update_lines = update.readlines

#   old_lines.each do |e|
#     arr_a.push(e)
#   end

#   update_lines.each do |f|
#     # puts f unless arr_a.include?(f)
#     arr_updates.push(f.parse_csv) unless arr_a.include?(f)
#   end
#   write_new(arr_updates) if arr_updates.count > 0
#   puts 'No new Ships found in this update...' if arr_updates.count.zero?
# end

# @ships.each do |ship|
#   name = ship['displayProperties']['name']
#   next if ship['displayProperties']['name'].include?('/')
#   File.open("ship_imgs/#{name}.jpg", 'wb') do |fo|
#     fo.write open("https://bungie.net#{ship['screenshot']}").read
#   end
# end
