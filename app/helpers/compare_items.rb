require_relative './write.rb'
require 'csv'

class CompareItems

  # include CSV
  include Write

  def initialize(item_type, old_file_date)
    @item_type = item_type
    @old_file_date = old_file_date
  end

  def compare
    arr_a = []
    updates_arr = []
    puts "Comparing #{@item_type.capitalize}..."
    old = File.open("d2_#{@item_type}_simple_#{@old_file_date}.csv")
    update = File.open("d2_#{@item_type}_simple_#{Date.today}.csv")
    old_lines = old.readlines
    update_lines = update.readlines

    old_lines.each do |e|
      arr_a.push(e)
    end

    update_lines.each do |f|
      updates_arr.push(f.parse_csv) unless arr_a.include?(f)
    end
    Write.results_csv(updates_arr, @item_type) if updates_arr.count > 0
    puts "No new #{@item_type.capitalize} found in this update..." if updates_arr.count.zero?
  end

end
