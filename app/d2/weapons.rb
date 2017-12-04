require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require "open-uri"
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
      # next if weapon['displayProperties']['name'].include?('/')
      # File.open("#{category}_imgs/#{weapon['displayProperties']['name']}.jpg", 'w+') do |fo|
      #   fo.write open("https://bungie.net#{weapon['screenshot']}").read
      # end
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
CSV.open('d2_weapons_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text weapon_type image_url screenshot_url]
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
