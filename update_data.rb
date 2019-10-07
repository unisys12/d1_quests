require_relative './app/d2/item_sets/items.rb'
require_relative './app/d2/armor.rb'
require_relative './app/d2/emblems.rb'
require_relative './app/d2/ghosts.rb'
require_relative './app/d2/ornaments.rb'
require_relative './app/d2/shaders.rb'
require_relative './app/d2/ships.rb'
require_relative './app/d2/sparrows.rb'
require_relative './app/d2/treasure_maps.rb'
require_relative './app/d2/weapons.rb'
# require './app/helpers/compare_items.rb'
# File to compare update against
# old_file_date = '2018-01-16'

# update_item_sets

puts '--- Warlock Armor ---'
update_armor(21)

puts '--- Titan Armor ---'
update_armor(22)

puts '--- Hunter Armor ---'
update_armor(23)

# hunter = CompareItems.new('hunter', old_file_date)
# hunter.compare

# titan = CompareItems.new('titan', old_file_date)
# titan.compare

# warlock = CompareItems.new('warlock', old_file_date)
# warlock.compare
# compare_armor("Hunter")
# compare_armor("Titan")
# compare_armor("Warlock")

update_emblems
# emblems = CompareItems.new('emblems', old_file_date)
# emblems.compare

update_ghosts
# ghosts = CompareItems.new('ghosts', old_file_date)
# ghosts.compare

update_ornaments
# ornaments = CompareItems.new('ornaments', old_file_date)
# ornaments.compare

update_shaders
# shaders = CompareItems.new('shaders', old_file_date)
# shaders.compare

update_ships
# ships = CompareItems.new('ships', old_file_date)
# ships.compare

update_sparrows
# compare_sparrows
# # sparrows = CompareItems.new('sparrows', old_file_date)
# sparrows.compare

update_treasure_maps

puts '--- Power Weapons ---'
update_weapon_groups(4)

puts '--- Energy Weapons ---'
update_weapon_groups(3)

puts '--- Kinetic Weapons ---'
update_weapon_groups(2)

update_all_weapons
# weapons = CompareItems.new('weapons', old_file_date)
# weapons.compare
