require './app/helpers/compare_activities.rb'

destinations = [
    'earth',
    'io',
    'mars',
    'mercury',
    'nessus orbit',
    'nessus',
    'the moon',
    'titan, moon of saturn'
]

destinations.each do |destination|
    dest_stories = CompareActivities.new('./app/d2/pre_shadowkeep/' + destination + '_stories.csv', './app/d2/shadowkeep/' + destination + '_stories.csv')
    dest_stories.compare

    dest_adventures = CompareActivities.new('./app/d2/pre_shadowkeep/' + destination + '_adventures.csv', './app/d2/shadowkeep/' + destination + '_adventures.csv')
    dest_adventures.compare

    dest_strikes = CompareActivities.new('./app/d2/pre_shadowkeep/' + destination + '_strikes.csv', './app/d2/shadowkeep/' + destination + '_strikes.csv')
    dest_strikes.compare
end

# earth_stories = CompareActivities.new('./app/d2/pre_shadowkeep/Earth_stories.csv', './app/d2/shadowkeep/Earth_stories.csv')
# earth_stories.compare

# earth_adventures = CompareActivities.new('./app/d2/pre_shadowkeep/Earth_adventures.csv', './app/d2/shadowkeep/Earth_adventures.csv')
# earth_adventures.compare

# earth_strikes = CompareActivities.new('./app/d2/pre_shadowkeep/Earth_strikes.csv', './app/d2/shadowkeep/Earth_strikes.csv')
# earth_strikes.compare

# io_stories = CompareActivities.new('./app/d2/pre_shadowkeep/io_stories.csv', './app/d2/shadowkeep/io_stories.csv')
# io_stories.compare

# io_adventures = CompareActivities.new('./app/d2/pre_shadowkeep/io_adventures.csv', './app/d2/shadowkeep/io_adventures.csv')
# io_adventures.compare

# io_strikes = CompareActivities.new('./app/d2/pre_shadowkeep/io_strikes.csv', './app/d2/shadowkeep/io_strikes.csv')
# io_strikes.compare