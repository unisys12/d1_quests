require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_URL'], ENV['DB_USER'], ENV['DB_USER'], ENV['DB_PASSWORD'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@shaders = item_defs.find(itemCategoryHashes: 41)

CSV.open('d2_shaders_simple.csv', 'wb') do |csv|
  csv << %w[name flavor_text image_url]
  @shaders.each do |shader|
    csv << [
      shader['displayProperties']['name'],
      shader['displayProperties']['description'],
      "https://bungie.net#{shader['displayProperties']['icon']}"
    ]
    # File.open("shader_imgs/#{shader['displayProperties']['name']}.jpg", 'w+') do |fo|
    #   next if shader['displayProperties']['name'] == 'Default Shader'
    #   fo.write open("https://bungie.net#{shader['displayProperties']['icon']}").read
    # end
  end
end
