require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

@ItemDefs = client['destiny.manifest.en.DestinyInventoryItemDefinition']

@quests = @ItemDefs.find(bucketTypeHash: 3621873013.0)

def step_counts(hash)
  @step_count = hash.count
  hash.count
end

CSV.open('destiny_one_quests.csv', 'wb') do |csv|
  csv << %w[name displaySource itemDescription icon secondaryIcon numberOfSteps quest_steps]
  @quests.each do |item|
    next unless item['itemName'] && item['itemDescription'] || item['displaySource']
    csv << [
      item['itemName'],
      item['itemDescription'],
      item['displaySource'],
      'https://bungie.net' + item['icon'],
      'https://bungie.net' + item['secondaryIcon'],
      step_counts(item['setItemHashes'])
    ]
    next unless @step_count > 0
    CSV.open("#{item['itemName']}_steps.csv", 'wb') do |step_csv|
      puts "Creating #{item['itemName']}_steps.csv..."
      step_csv << %w[name displaySource itemDescription icon secondaryIcon]
      item['setItemHashes'].each do |hash|
        steps = @ItemDefs.find(_id: hash)
        steps.each do |step|
          step_csv << [
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
end
