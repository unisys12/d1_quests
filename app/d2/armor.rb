require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
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

# def compare_armor(klass)
#   arr_updates = []
#   puts "Comparing #{klass} Armor..."
#   old = File.open("d2_#{klass}_armor_simple_2018-01-16.csv")
#   update = File.open("d2_#{klass}_armor_simple_#{Date.today}.csv")

#   old_lines = old.readlines
#   update_lines = update.readlines
#   arr_a = []

#   old_lines.each do |e|
#     arr_a.push(e.parse_csv) unless update_lines.include?(e)
#   end
#   Util.write_new(arr_updates, 'Armor') if arr_updates.count > 0
#   puts 'No new Armor found in this update' if arr_updates.count.zero?
# end

# compare("Hunter")
# compare("Titan")
# compare("Warlock")
