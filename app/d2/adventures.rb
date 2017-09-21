require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

activity_defs = client['destiny2.manifest.en.DestinyActivityDefinition']
@place_defs = client['destiny2.manifest.en.DestinyPlaceDefinition']

@adventures = activity_defs.find(activityTypeHash: 3497767639.0, tier: 0)

def resolve_place(hash)
  instance = @place_defs.find(_id: hash)
  instance.each do |place|
    return place['displayProperties']['name']
  end
end

def list_adventures(hash)
  @adventures.each do |adventure|
    next unless adventure['placeHash'] == hash
    puts adventure['displayProperties']['name']
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
