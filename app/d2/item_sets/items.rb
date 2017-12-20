require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

@item_defs = db['destiny2.en.DestinyInventoryItemDefinition']
@category_defs = db['destiny2.en.DestinyItemCategoryDefinition']

@armor_sets = @item_defs.find( itemTypeDisplayName: 'Armor Set' )

def resolve_category(hash)
  categories = @category_defs.find(_id: hash)
  categories.each do |cat|
    return cat['shortTitle']
  end
end

def fetch_item(hash)
  item = @item_defs.find( _id: hash )
  group = []
  item.each do |value|
    group.push(value['displayProperties']['name'])
    group.push(value['displayProperties']['description'])
    group.push("https://bungie.net#{value['screenshot']}")
    group.push(resolve_category(value['itemCategoryHashes'][0]))
    group.push(resolve_category(value['itemCategoryHashes'][1]))
    group.push(resolve_category(value['itemCategoryHashes'][2]))
  end
  group
end

def update_item_sets
  puts 'Fetching Weapon and Armor set data...'
  @armor_sets.each do |set|
    CSV.open("data/#{Date.today}_update/#{set['displayProperties']['name']}.csv", 'a+') do |csv|
      csv << %w[name description screenshot type_1 type_2 type_3]
      set['gearset']['itemList'].each do |item|
        csv << fetch_item(item)
      end
    end
  end
end
