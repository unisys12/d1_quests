require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['DestinyInventoryItemDefinition']
@category_defs = db['DestinyItemCategoryDefinition']

@armors = item_defs.find(itemCategoryHashes: 20)

def resolve_class(hash)
  categories = @category_defs.find(_id: hash)
  categories.each do |cat|
    return cat['displayProperties']['name']
  end
end

def update_armor(hash)
  character_class = resolve_class(hash)
  CSV.open("d2_#{character_class}_simple_#{Date.today}.csv", 'wb') do |csv|
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
