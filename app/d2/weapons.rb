require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
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

def new_weapons(data)
  puts 'Writing new file...'
  CSV.open("d2_new_weapons_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text weapon_type image_url screenshot_url]
    data.each do |row|
      csv << [
        row['name'],
        row['flavor_text'],
        row['weapon_type'],
        row['image_url'],
        row['screenshot_url']
      ]
    end
  end
  puts 'Done!'
end

def compare_weapons
  weapons = []
  puts 'Comparing Weapons...'
  old_file = CSV.read('d2_weapons_simple_2017-12-19.csv', headers: true)
  new_file = CSV.read("d2_weapons_simple_2018-01-16.csv", headers: true)

  old = old_file
  update = new_file

  update.each do |weapon|
   weapons.push(weapon) unless update.include?(old)
  end
  puts "  Found #{weapons.length} new weapons..."
  new_weapons(weapons)
end

compare_weapons
