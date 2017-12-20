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

def update_armor(hash)
  character_class = resolve_class(hash)
  CSV.open("d2_#{character_class}_armor_simple_#{Date.today}.csv", 'wb') do |csv|
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

def compare(klass)
  old = CSV.table("d2_#{klass}_armor_simple_12_12.csv")
  update = CSV.table("d2_#{klass}_armor_simple_#{Date.today}.csv")

  if update == old
    puts 'No new items found...'
    exit
  else
    puts 'new items listed...'
    new_hash = update.to_a - old.to_a
    puts "#{new_hash.count} new #{klass} Armor in the this update..."
    new_hash.flatten
  end

  CSV.open("d2_new_#{klass}_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name description type image_url screenshot_url]
    new_hash.each do |item|
      csv << [
        item[0],
        item[1],
        item[2],
        item[3],
        item[4]
      ]
    end
  end
end

compare("Hunter")
compare("Titan")
compare("Warlock")
