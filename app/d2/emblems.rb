require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
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
