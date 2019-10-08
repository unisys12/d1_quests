require_relative './write.rb'
require 'csv'

class CompareActivities

    include Write
    
    def initialize(old_path, new_path)
        @old_path = old_path
        @new_path = new_path
    end

    def compare()
        old_activities = []
        new_activities = []

        puts "Comparing activities... "

        old_file = File.open(@old_path)
        new_file = File.open(@new_path)

        file_name = File.basename(@new_path, '.*')

        old_rows = old_file.readlines
        new_rows = new_file.readlines

        old_rows.each do |row|
            old_activities.push(row)
        end

        new_rows.each do |update|
            new_activities.push(update.parse_csv) unless old_activities.include?(update)
            # puts update unless old_activities.include?(update)
        end

        # puts new_activities

        Write.results_csv(new_activities.uniq, file_name) if new_activities.count > 0
        puts "No new #{file_name.capitalize} found in this update..." if new_activities.count.zero?
    end

end
