require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@emblems = item_defs.find(itemCategoryHashes: 19)

def update_emblems
  CSV.open("d2_emblems_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name icon_url secondary_icon secondary_overlay secondary_specical]
    puts 'Fetching Emblem data...'
    @emblems.each do |emblem|
      csv << [
        emblem['displayProperties']['name'],
        "https://bungie.net#{emblem['displayProperties']['icon']}",
        "https://bungie.net#{emblem['secondaryIcon']}",
        "https://bungie.net#{emblem['secondaryOverlay']}",
        "https://bungie.net#{emblem['secondarySpecial']}"
      ]
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['displayProperties']['icon']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondaryIcon.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondaryIcon']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondaryOverlay.png", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondaryOverlay']}").read
      # end
      # File.open("emblem_imgs/#{emblem['displayProperties']['name']}_secondarySpecial.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{emblem['secondarySpecial']}").read
      # end
    end
  end
end

def compare_emblems
  puts 'Comparing Emblems...'
  old = CSV.table('d2_emblems_simple_2017-12-19.csv')
  update = CSV.table("d2_emblems_simple_#{Date.today}.csv")

  if update == old
    puts '    No new items found...'
  else
    puts '    new items listed...'
    new_hash = update.to_a - old.to_a
    puts "    #{new_hash.count} new emblems in the this update..."
    new_hash.flatten

    CSV.open("d2_new_emblems_#{Date.today}.csv", 'wb') do |csv|
      csv << %w[name icon_url secondary_icon secondary_overlay secondary_specical]
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
end

# compare
