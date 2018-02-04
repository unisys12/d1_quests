require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'dotenv/load'
# require 'open-uri'
require_relative '../db/connect'

client = DB.new(ENV['DB_LOCAL'])
db = client.conn

item_defs = db['destiny2.en.DestinyInventoryItemDefinition']

@ghosts = item_defs.find(itemCategoryHashes: 39)

def update_ghosts
  CSV.open("d2_ghosts_simple_#{Date.today}.csv", 'wb') do |csv|
    csv << %w[name flavor_text image_url screenshot_url]
    puts 'Fetching Ghost data...'
    @ghosts.each do |ghost|
      csv << [
        ghost['displayProperties']['name'],
        ghost['displayProperties']['description'],
        "https://bungie.net#{ghost['displayProperties']['icon']}",
        "https://bungie.net#{ghost['screenshot']}"
      ]
      # File.open("ghost_imgs/#{ghost['displayProperties']['name']}.jpg", 'wb') do |fo|
      #   fo.write open("https://bungie.net#{ghost['screenshot']}").read
      # end
    end
  end
end

# def compare_ghosts
#   updates_arr = []
#   puts 'Comparing Ghosts...'
#   old = File.open('d2_ghosts_simple_2018-01-16.csv')
#   update = File.open("d2_ghosts_simple_#{Date.today}.csv")

#   arr_a = []

#   old_lines = old.readlines
#   update_lines = update.readlines

#   old_lines.each do |e|
#     arr_a.push(e)
#   end

#   update_lines.each do |f|
#     # puts f unless arr_a.include?(f)
#     updates_arr.push(f.parse_csv) unless arr_a.include?(f)
#   end
#   Util.write_new(updates_arr, 'Ghosts') if updates_arr.count > 0
#   puts 'No new Ghosts found in this update...' if updates_arr.count.zero?
# end
