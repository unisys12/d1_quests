require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'csv'
require 'dotenv/load'

Mongo::Logger.level = Logger::FATAL

client = Mongo::Client.new([ENV['DB_URL']], database: ENV['DB_USER'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD'])

@item_defs = client['destiny.manifest.en.DestinyInventoryItemDefinition']

@weapons = @item_defs.find(itemCategoryHashes: 1)

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

CSV.open('d1_weapons.csv', 'wb') do |csv|
  csv << %w[
    name
    description 
    icon 
    tierTypeName 
    itemTypeName 
    stability 
    value 
    minimum 
    maximum 
    attack 
    value 
    minimum
    maximum
    equip_speed
    value 
    minimum
    maximum
    range
    value 
    minimum
    maximum
    aim_assist
    value 
    minimum
    maximum
    inventory_size
    value 
    minimum
    maximum
    light
    value 
    minimum
    maximum
    recoil_direction
    value 
    minimum
    maximum
    optics(zoom_multiplier)
    value 
    minimum
    maximum
    magizine
    value 
    minimum
    maximum
    impact
    value 
    minimum
    maximum
    reload
    value 
    minimum
    maximum
    rate_of_fire
    value 
    minimum
    maximum
    ]
  @weapons.each do |weapon|
    weapon_stats(weapon['stats'], weapon['itemName'])
    csv << [
      weapon['itemName'],
      weapon['itemDescription'],
      'https://bungie.net' + weapon['icon'],
      weapon['tierTypeName'],
      weapon['itemTypeName'],
      ' ',
      @stats[0]['value'],
      @stats[0]['minimum'],
      @stats[0]['maximum'],
      ' ',
      @stats[1]['value'],
      @stats[1]['minimum'],
      @stats[1]['maximum'],
      ' ',
      @stats[2]['value'],
      @stats[2]['minimum'],
      @stats[2]['maximum'],
      ' ',
      @stats[3]['value'],
      @stats[3]['minimum'],
      @stats[3]['maximum'],
      ' ',
      @stats[4]['value'],
      @stats[4]['minimum'],
      @stats[4]['maximum'],
      ' ',
      @stats[5]['value'],
      @stats[5]['minimum'],
      @stats[5]['maximum'],
      ' ',
      @stats[6]['value'],
      @stats[6]['minimum'],
      @stats[6]['maximum'],
      ' ',
      @stats[7]['value'],
      @stats[7]['minimum'],
      @stats[7]['maximum'],
      ' ',
      @stats[8]['value'],
      @stats[8]['minimum'],
      @stats[8]['maximum'],
      ' ',
      @stats[9]['value'],
      @stats[9]['minimum'],
      @stats[9]['maximum'],
      ' ',
      @stats[10]['value'],
      @stats[10]['minimum'],
      @stats[10]['maximum'],
      ' ',
      @stats[11]['value'],
      @stats[11]['minimum'],
      @stats[11]['maximum'],
      ' ',
      @stats[12]['value'],
      @stats[12]['minimum'],
      @stats[12]['maximum']
    ]
  end
end
