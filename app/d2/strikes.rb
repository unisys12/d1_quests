require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'
# require_relative '../db/connect'

client = Mongo::Client.new("mongodb://localhost:27017", :database => 'Local_Armory');
db = client.database

@activity_defs = db['destiny2.manifest.en.DestinyActivityDefinition']

@strikes = @activity_defs.find(activityTypeHash: 4110605575.0 || 2889152536.0 || 4164571395.0)


# NOT WORKING
def strike_missions
  puts "-- Reading Strikes --"
  @strikes.each do |strike|
    puts strike
  end
#   CSV.open('strike_missions.csv', 'w', headers: true) do |csv|
#     csv << %w[hash name activity_level activity_light_level]
#     @strikes.each do |mission|
#       next unless mission['displayProperties']['name']
#       csv << [
#         mission['hash'],
#         mission['displayProperties']['name'],
#         mission['activityLevel'],
#         mission['activityLightLevel']
#       ]
#     end
#   end
end

strike_missions
