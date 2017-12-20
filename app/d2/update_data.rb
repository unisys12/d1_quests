require_relative './item_sets/items.rb'
require_relative './armor.rb'
require_relative './emblems.rb'
require_relative './ghosts.rb'
require_relative './ornaments.rb'
require_relative './shaders.rb'
require_relative './ships.rb'
require_relative './sparrows.rb'
require_relative './treasure_maps.rb'
require_relative './weapons.rb'

update_item_sets

puts '--- Warlock Armor ---'
update_armor(21)

puts '--- Titan Armor ---'
update_armor(22)

puts '--- Hunter Armor ---'
update_armor(23)

update_emblems
update_ghosts
update_ornaments
update_shaders
update_ships
update_sparrows
update_treasure_maps

puts '--- Power Weapons ---'
update_weapon_groups(4)

puts '--- Energy Weapons ---'
update_weapon_groups(3)

puts '--- Kinetic Weapons ---'
update_weapon_groups(2)

update_all_weapons
