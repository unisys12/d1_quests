require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']
@category_defs = db['destiny2.en.DestinyItemCategoryDefinition']

@armors = item_defs.find(itemCategoryHashes: 20)

def resolve_class(hash)
  categories = @category_defs.find(_id: hash)
  categories.each do |cat|
    return cat['displayProperties']['name']
  end
end

def list_armor(hash)
  character_class = resolve_class(hash)
  CSV.open("d2_#{character_class}_armor_simple_12_12.csv", 'wb') do |csv|
    csv << %w[name description type image_url screenshot_url]
    @armors.each do |armor|
      next unless armor['itemCategoryHashes'][0] == hash
      csv << [
        armor['displayProperties']['name'],
        armor['displayProperties']['description'],
        armor['itemTypeDisplayName'],
        "https://bungie.net#{armor['displayProperties']['icon']}",
        "https://bungie.net#{armor['screenshot']}"
      ]
    end
  end
end

puts '--- Warlock ---'
list_armor(21)

puts '--- Titan ---'
list_armor(22)

puts '--- Hunter ---'
list_armor(23)
