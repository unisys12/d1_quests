require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@ghosts = item_defs.find(itemCategoryHashes: 39)

def update_ghosts
  CSV.open("d2_ghosts_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    puts 'Fetching Ghost data...'
    @ghosts.each do |ghost|
      csv << [
        ghost['displayProperties']['name'],
        ghost['displayProperties']['description'],
        "https://bungie.net#{ghost['displayProperties']['icon']}",
        "https://bungie.net#{ghost['screenshot']}"
      ]
      # File.open("ghost_imgs/#{ghost['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{ghost['screenshot']}").read
      # end
    end
  end
end

def compare
  old = CSV.table('d2_ghosts_simple_12_12.csv')
  update = CSV.table("d2_ghosts_simple_#{Date.today}.csv")
 
  if update == old
    puts 'No new items found...'
    exit
  else
    puts 'new items listed...'
    new_hash = update.to_a - old.to_a
    puts "#{new_hash.count} new Ghosts in the this update..."
    new_hash.flatten
  end
 
  CSV.open("d2_new_Ghosts_simple_#{Date.today}.csv", 'wb') do |csv|
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

compare
