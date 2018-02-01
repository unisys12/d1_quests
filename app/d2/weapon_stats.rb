require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']
@stat_def = db['destiny2.en.DestinyStatDefinition']
@weapons = item_defs.find(itemCategoryHashes: 1)

@stats = {}

def weapon_stats(hash, name)
  puts "---- #{name} ----"
  hash.each_with_index do |stat, i|
    @stats[i] = {
      'value' => stat[1]['value'],
      'minimum' => stat[1]['minimum'],
      'maximum' => stat[1]['maximum']
    }
  end
end

CSV.open('d2_weapon_stats.csv', 'wb') do |csv|
  csv << %w[
    name
    icon
    tierTypeName
    itemTypeName
    stability
    minimum
    maximum
    handling
    minimum
    maximum
    aim_assist
    minimum
    maximum
    attack
    minimum
    maximum
    _unknown_
    minimum
    maximum
    _unknown_
    minimum
    maximum
    power
    minimum
    maximum
    velocity
    minimum
    maximum
    recoil_direction
    minimum
    maximum
    zoom
    minimum
    maximum
    blast_radius
    minimum
    maximum
    magazine
    minimum
    maximum
    reload_speed
    minimum
    maximum
    rounds_per_minute
    minimum
    maximum
    ]
  @weapons.each do |weapon|
    weapon_stats(weapon['stats']['stats'], weapon['displayProperties']['name'])
    csv << [
      weapon['displayProperties']['name'],
      'https://bungie.net' + weapon['displayProperties']['icon'],
      weapon['inventory']['tierTypeName'],
      weapon['itemTypeDisplayName'],
      @stats[0]['value'],
      @stats[0]['minimum'],
      @stats[0]['maximum'],
      @stats[1]['value'],
      @stats[1]['minimum'],
      @stats[1]['maximum'],
      @stats[2]['value'],
      @stats[2]['minimum'],
      @stats[2]['maximum'],
      @stats[3]['value'],
      @stats[3]['minimum'],
      @stats[3]['maximum'],
      @stats[4]['value'],
      @stats[4]['minimum'],
      @stats[4]['maximum'],
      @stats[5]['value'],
      @stats[5]['minimum'],
      @stats[5]['maximum'],
      @stats[6]['value'],
      @stats[6]['minimum'],
      @stats[6]['maximum'],
      @stats[7]['value'],
      @stats[7]['minimum'],
      @stats[7]['maximum'],
      @stats[8]['value'],
      @stats[8]['minimum'],
      @stats[8]['maximum'],
      @stats[9]['value'],
      @stats[9]['minimum'],
      @stats[9]['maximum'],
      @stats[10]['value'],
      @stats[10]['minimum'],
      @stats[10]['maximum'],
      @stats[11]['value'],
      @stats[11]['minimum'],
      @stats[11]['maximum'],
      @stats[12]['value'],
      @stats[12]['minimum'],
      @stats[12]['maximum'],
      @stats[13]['value'],
      @stats[13]['minimum'],
      @stats[13]['maximum']
    ]
  end
end
