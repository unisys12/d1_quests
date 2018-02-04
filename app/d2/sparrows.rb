require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
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

# def write_new(updates)
#   puts "Writing file containing #{updates.count} new Sparrows from this update..."
#   CSV.open("d2_new_Sparrows_#{Date.today}.csv", 'wb') do |csv|
#     csv << %w[name flavor_text image_url screenshot_url]
#     updates.each do |update|
#       csv << update
#     end
#   end
# end

# def compare_sparrows
#   arr_updates = []
#   puts 'Comparing Sparrows...'
#   old = File.open('d2_sparrows_simple_2018-01-16.csv')
#   update = File.open("d2_sparrows_simple_#{Date.today}.csv")

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
#   puts 'No new Sparrows found in this update...' if arr_updates.count.zero?
# end
