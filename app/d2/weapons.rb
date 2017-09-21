require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

item_defs = client['destiny2.manifest.en.DestinyInventoryItemDefinition']
@category_defs = client['destiny2.manifest.en.DestinyItemCategoryDefinition']

@weapons = item_defs.find(itemCategoryHashes: 1)

def resolve_category(hash)
  category = @category_defs.find(_id: hash)
  category.each do |cat|
    return cat['displayProperties']['name']
  end
end

def list_weapons(hash)
  category = resolve_category(hash)
  CSV.open("d2_#{category}_simple.csv", 'wb') do |csv|
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

puts '--- Power Weapons ---'
list_weapons(4)

puts '--- Energy Weapons ---'
list_weapons(3)

puts '--- Kinetic Weapons ---'
list_weapons(2)

# ALL WEAPONS
# CSV.open('d2_weapons_simple.csv', 'wb') do |csv|
#   csv << %w[name flavor_text weapon_type image_url screenshot_url]
#   @weapons.each do |weapon|
#     csv << [
#       weapon['displayProperties']['name'],
#       weapon['displayProperties']['description'],
#       weapon['itemTypeDisplayName'],
#       "https://bungie.net#{weapon['displayProperties']['icon']}",
#       "https://bungie.net#{weapon['screenshot']}"
#     ]
#   end
# end
