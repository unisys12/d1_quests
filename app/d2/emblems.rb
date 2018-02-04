require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@emblems = item_defs.find(itemCategoryHashes: 19)

def update_emblems
  CSV.open("d2_emblems_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name icon_url secondary_icon secondary_overlay secondary_specical]
    puts 'Fetching Emblem data...'
    @emblems.each do |emblem|
      csv << [
        emblem['displayProperties']['name'],
        "https://bungie.net#{emblem['displayProperties']['icon']}",
        "https://bungie.net#{emblem['secondaryIcon']}",
        "https://bungie.net#{emblem['secondaryOverlay']}",
        "https://bungie.net#{emblem['secondarySpecial']}"
      ]
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['displayProperties']['icon']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondaryIcon.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondaryIcon']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondaryOverlay.png", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondaryOverlay']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondarySpecial.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondarySpecial']}").read
      # end
    end
  end
end

# def compare_emblems
#   arr_updates = []
#   puts 'Comparing Emblems...'
#   old = File.open('d2_emblems_simple_2018-01-16.csv')
#   update = File.open('d2_emblems_simple_2018-01-31.csv')

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
#   write_new(arr_updates, 'Emblems') if arr_updates.count > 0
#   puts 'No new Emblems found in this update...' if arr_updates.count.zero?
# end

# compare_emblems
