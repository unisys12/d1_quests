require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'date'
require 'dotenv/load'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

@activity_defs = db['destiny2.en.DestinyActivityDefinition']

@stories = @activity_defs.find(activityTypeHash: 1686739444)

# CSV.open("story_missions_#{Date.today}.csv", 'wb',) do |csv|
#   csv << %w[name description activity_level activity_light_level]
  @stories.each do |mission|
    next unless mission['displayProperties']['name']
    puts mission['displayProperties']['name']
    # csv << [
    #   mission['displayProperties']['name'],
    #   mission['displayProperties']['description'],
    #   mission['activityLevel'],
    #   mission['activityLightLevel']
    # ]
  end
# end
