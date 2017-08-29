require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

ItemDefs = client['destiny.manifest.en.DestinyInventoryItemDefinition']

@items = ItemDefs.find(itemName: 'Legend of the Hunter')

CSV.open('legend_of_the_hunter.csv', 'wb') do |csv|
  csv << %w[quest_name quest_displaySource quest_itemDescription quest_icon quest_secondaryIcon]
end

CSV.open('legend_of_the_hunter.csv', 'a+') do |csv|
  @items.each do |item|
    csv << [
      item['itemName'],
      item['itemDescription'],
      item['displaySource'],
      'https://bungie.net' + item['icon'],
      'https://bungie.net' + item['secondaryIcon']
    ]
  end
end

CSV.open('hunter_steps.csv', 'wb') do |write|
  write << %w[step_name step_displaySource step_itemDescription step_icon step_secondaryIcon]
end

@items.each do |item|
  item['setItemHashes'].each do |step_hash|
    steps = ItemDefs.find(_id: step_hash)
    steps.each do |step|
      CSV.open('hunter_steps.csv', 'a+') do |pencil|
        pencil << [
          step['itemName'],
          step['itemDescription'],
          step['displaySource'],
          'https://bungie.net' + step['icon'],
          'https://bungie.net' + step['secondaryIcon']
        ]
      end
    end
  end
end
