module Write
  def Write.results_csv(updates, category)
    puts "Writing file containing #{updates.count} new #{category.capitalize} from this update..."
    CSV.open("d2_new_#{category.capitalize}_#{Date.today}.csv", 'wb') do |csv|
      updates.each do |update|
        csv << update
      end
    end
  end
end
