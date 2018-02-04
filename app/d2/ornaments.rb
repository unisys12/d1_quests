require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@ornaments = item_defs.find(itemCategoryHashes: 56)

def update_ornaments
  CSV.open("d2_ornaments_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url]
    puts 'Fetching Ornament data...'
    @ornaments.each do |ornament|
      next unless ornament['itemTypeDisplayName'].index(/Ornament/i)
      csv << [
        ornament['displayProperties']['name'],
        ornament['displayProperties']['description'],
        "https://bungie.net#{ornament['displayProperties']['icon']}"
      ]
      # File.open("ornament_imgs/#{ornament['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{ornament['displayProperties']['icon']}").read
      # end
    end
  end
end

# def compare_ornaments
#   arr_updates = []
#   puts 'Comparing Ornaments...'
#   old = File.open('d2_ornaments_simple_2018-01-16.csv')
#   update = File.open("d2_ornaments_simple_#{Date.today}.csv")

#   arr_a = []

#   old_lines = old.readlines
#   update_lines = update.readlines

#   old_lines.each do |e|
#     arr_a.push(e)
#   end

#   update_lines.each do |f|
#     arr_updates.push(f.parse_csv) unless arr_a.include?(f)
#   end
#   Util.write_new(arr_updates, 'Ornaments') if arr_updates.count > 0
#   puts 'No new Ornaments found in this update...' if arr_updates.count.zero?
# end
