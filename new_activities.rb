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