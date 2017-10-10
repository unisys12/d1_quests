require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

@item_defs = db['destiny2.en.DestinyInventoryItemDefinition']
@lore_defs = db['destiny2.en.DestinyLoreDefinition']

def fetch_lore(hash)
  lore = @lore_defs.find(_id: hash)
  lore.each do |row|
    card = row['displayProperties']['description']
    card ||= '' if row['displayProperties']['description'].nil?
    return card
  end
end

def resolve_phrase(phrase)
  items = @item_defs.find("displayProperties.description": /#{phrase}/)
  CSV.open("#{phrase}_usage.csv", 'wb') do |csv|
    csv << %w[name description icon lore_description]
    items.each do |item|
      csv << [
        item['displayProperties']['name'],
        item['displayProperties']['description'],
        "https://bungie.net#{item['displayProperties']['icon']}",
        fetch_lore(item['loreHash'])
      ]
    end
  end
end

resolve_phrase("Light")
