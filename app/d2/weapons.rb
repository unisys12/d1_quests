require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn
item_defs = db['destiny2.en.DestinyInventoryItemDefinition']
@category_defs = db['destiny2.en.DestinyItemCategoryDefinition']
@weapons = item_defs.find(itemCategoryHashes: 1)

def resolve_category(hash)
  categories = @category_defs.find(_id: hash)
  categories.each do |cat|
    return cat['displayProperties']['name']
  end
end

def update_weapon_groups(hash)
  category = resolve_category(hash)
  CSV.open("d2_#{category}_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text weapon_type image_url screenshot_url]
    @weapons.each do |weapon|
      next unless weapon['itemCategoryHashes'][0] == hash
      csv << [
        weapon['displayProperties']['name'],
        weapon['displayProperties']['description'],
        weapon['itemTypeDisplayName'],
        "https://bungie.net#{weapon['displayProperties']['icon']}",
        "https://bungie.net#{weapon['screenshot']}"
      ]
    end
  end
end

# ALL WEAPONS
def update_all_weapons
  CSV.open("d2_weapons_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text weapon_type image_url screenshot_url]
    puts 'Updating all weapons...'
    @weapons.each do |weapon|
      csv << [
        weapon['displayProperties']['name'],
        weapon['displayProperties']['description'],
        weapon['itemTypeDisplayName'],
        "https://bungie.net#{weapon['displayProperties']['icon']}",
        "https://bungie.net#{weapon['screenshot']}"
      ]
    end
  end
end

# def write_new(updates)
#   puts "Writing file containing #{updates.count} new Weapons from this update..."
#   CSV.open("d2_new_weapons_#{Date.today}.csv", 'wb') do |csv|
#     csv << %w[name flavor_text weapon_type image_url screenshot_url]
#     updates.each do |update|
#       csv << update
#     end
#   end
# end

# def compare_weapons
#   arr_updates = []
#   puts 'Comparing Ghosts...'
#   old = File.open('d2_weapons_simple_2018-01-16.csv')
#   update = File.open("d2_weapons_simple_#{Date.today}.csv")

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
#   puts 'No new Weapons found in this update...' if arr_updates.count.zero?
# end
