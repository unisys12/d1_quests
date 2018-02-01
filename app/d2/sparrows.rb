require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@sparrows = item_defs.find(itemCategoryHashes: 43)

def update_sparrows
  CSV.open("d2_sparrows_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    puts 'Fetching Sparrow data...'
    @sparrows.each do |sparrow|
      csv << [
        sparrow['displayProperties']['name'],
        sparrow['displayProperties']['description'],
        "https://bungie.net#{sparrow['displayProperties']['icon']}",
        "https://bungie.net#{sparrow['screenshot']}"
      ]
      # File.open("sparrow_imgs/#{sparrow['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{sparrow['screenshot']}").read
      # end
    end
  end
end

def compare
  old = CSV.table('d2_sparrows_simple_2018-01-16.csv')
  update = CSV.table("d2_sparrows_simple_#{Date.today}.csv")
 
  if update == old
    puts 'No new items found...'
    exit
  else
    puts 'new items listed...'
    new_hash = update.to_a - old.to_a
    puts "#{new_hash.count} new Ships in the this update..."
    new_hash.flatten
  end
 
  CSV.open("d2_new_Shaders_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    new_hash.each do |items|
      csv << [
        items[0],
        items[1],
        items[2],
        items[3]
      ]
    end
  end
end

# compare
