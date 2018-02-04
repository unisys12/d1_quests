require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require "open-uri"
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@shaders = item_defs.find(itemCategoryHashes: 41)

def update_shaders
  CSV.open("d2_shaders_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url]
    puts 'Fetching Shader data...'
    @shaders.each do |shader|
      csv << [
        shader['displayProperties']['name'],
        shader['displayProperties']['description'],
        "https://bungie.net#{shader['displayProperties']['icon']}"
      ]
      # File.open("shader_imgs/#{shader['displayProperties']['name']}.jpg", 'w+') do |fo|
      #   next if shader['displayProperties']['name'] == 'Default Shader'
      #   fo.write open("https://bungie.net#{shader['displayProperties']['icon']}").read
      # end
    end
  end
end

# def compare_shaders
#   arr_updates = []
#   puts 'Comparing Ghosts...'
#   old = File.open('d2_shaders_simple_2018-01-16.csv')
#   update = File.open("d2_shaders_simple_#{Date.today}.csv")

#   arr_a = []

#   old_lines = old.readlines
#   update_lines = update.readlines

#   old_lines.each do |e|
#     arr_a.push(e)
#   end

#   update_lines.each do |f|
#     # puts f unless arr_a.include?(f)
#     arr_updates.push(f.parse_csv) unless arr_a.include?(f)
#   end
#   Util.write_new(arr_updates, 'Shaders') if arr_updates.count > 0
#   puts 'No new Shaders found in this update...' if arr_updates.count.zero?
# end
