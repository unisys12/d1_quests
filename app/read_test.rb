require 'rubygems'
require 'bundler/setup'
require 'csv'
# require 'dotenv/load'

old = CSV.table('data/old/d2_Hunter_armor_simple.csv')
update = CSV.table('d2_Hunter_armor_simple_12_12.csv')

if update == old
  puts 'No new items found...'
  exit
else
  puts 'new items listed...'
  new_hash = update.to_a - old.to_a

  new_hash.flatten
end

CSV.open('d2_new_Hunter_armor_simple_12_12.csv', 'wb') do |csv|
  csv << %w[name description type image_url screenshot_url]
  new_hash.each do |weapon|
    csv << [
      weapon[0],
      weapon[1],
      weapon[2],
      weapon[3],
      weapon[4]
    ]
  end
end
