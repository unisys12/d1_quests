require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

activity_defs = db['destiny2.en.DestinyActivityDefinition']
@place_defs = db['destiny2.en.DestinyPlaceDefinition']

@adventures = activity_defs.find(activityTypeHash: 3497767639.0, tier: 0)
@stories = activity_defs.find( activityTypeHash: 1686739444 )
@strikes = activity_defs.find(activityTypeHash: 4110605575.0 || 2889152536.0 || 4164571395.0)

def resolve_place(hash)
  instance = @place_defs.find(_id: hash)
  instance.each do |place|
    return place['displayProperties']['name']
  end
end

@list = []

def list_adventures(hash)
  puts '--Adventures--'
  @adventures.each do |adventure|
    next unless adventure['placeHash'] == hash
    @list << adventure['displayProperties']['name']
    puts @list.uniq
    @list = []
  end
  puts '--Story Missions--'
  @stories.each do |mission|
    next unless mission['placeHash'] == hash
    @list << mission['displayProperties']['name']
    puts @list.uniq
    @list = []
  end
  puts '--Strikes--'
  @strikes.each do |strike|
    next unless strike['placeHash'] == hash
    @list << strike['displayProperties']['name']
    puts @list.uniq
    @list = []
  end
  puts ''
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
