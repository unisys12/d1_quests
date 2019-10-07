require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require 'mongo'
require_relative '../db/connect'

# client = DB.new(ENV['DB_LOCAL'])
Mongo::Logger.level = Logger::FATAL
client = Mongo::Client.new('mongodb://localhost:27017/Local_Armory')
# db = client.conn


activity_defs = client[:DestinyActivityDefinition]
@place_defs = client[:DestinyPlaceDefinition]

@adventures = activity_defs.find(activityTypeHash: 3497767639.0, tier: 0)
@stories = activity_defs.find( activityTypeHash: 1686739444 )
@strikes = activity_defs.find(activityTypeHash: 4110605575.0 || 2889152536.0 || 4164571395.0)


def resolve_place(hash)
  instance = @place_defs.find(hash: hash)
  instance.each do |place|
    return place['displayProperties']['name']
  end
end

def list_adventures(hash)
  puts ''
  puts '--Adventures--'
  CSV.open(resolve_place(hash) + '_adventures.csv', 'wb') do |csv|
    csv << %w[name discription]
    @adventures.each do |adventure|
        next unless adventure['placeHash'] == hash
        csv << [
          adventure['displayProperties']['name'],
          adventure['displayProperties']['description']
        ]
    end
  end

  puts ''
  puts '--Story Missions--'
  CSV.open(resolve_place(hash) + '_stories.csv', 'wb') do |csv|
    csv << %w[name discription]
    @stories.each do |story|
        next unless story['placeHash'] == hash
        csv << [
          story['displayProperties']['name'],
          story['displayProperties']['description']
        ]
    end
  end
  puts ''
  puts '--Strikes--'
  CSV.open(resolve_place(hash) + '_strikes.csv', 'wb') do |csv|
    csv << %w[name discription]
    @strikes.each do |strike|
        next unless strike['placeHash'] == hash
        csv << [
          strike['displayProperties']['name'],
          strike['displayProperties']['description']
        ]
    end
  end
end

puts "#Nessus"
list_adventures(3526908984.0)

puts "#Nessus _(The Emperor's Flagship)_"
list_adventures(330251492)

puts "#Earth"
list_adventures(3747705955.0)

puts "#Io"
list_adventures(4251857532.0)

puts "#Titan"
list_adventures(386951460)

puts "#Mercury"
list_adventures(1259908504)

puts "#Mars"
list_adventures(2426873752.0)

puts "#The Moon"
list_adventures(3325508439.0)

# CSV.open('d2_adventures.csv', 'wb') do |csv|
#   csv << %w[name discription place]
#   adventures.each do |adventure|
#     csv << [
#       adventure['displayProperties']['name'],
#       adventure['displayProperties']['description'],
#       resolve_place(adventure['placeHash'])
#     ]
#   end
# end
