require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'
require_relative './db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny.manifest.en.DestinyInventoryItemDefinition']
@all_items = item_defs.find()

CSV.open('d1_all_items.csv', 'wb') do |csv|
  csv << %w[
    name
    description
    tierTypeName
    itemTypeName
  ]

  @all_items.each do |item|
    puts '. '
    csv << [
      item['itemName'],
      item['itemDescription'],
      item['tierTypeName'],
      item['itemTypeName'],
    ]
  end
end
