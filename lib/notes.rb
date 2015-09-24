input = queried_race.to_sym.downcase
parsed_writing_data = parse_writing_proficiency_by_race
writing_grouped_by_race = parsed_writing_data.group_by {|hsh| hsh.fetch(:race_ethnicity).to_sym.downcase}
writing_data_for_queried_race = writing_grouped_by_race[input]
# writing_by_year = writing_data_for_queried_race[input].group_by {|hsh| hsh.fetch(:timeframe)}

parsed_reading_data = parse_reading_proficiency_by_race
reading_grouped_by_race = parsed_reading_data.group_by {|hsh| hsh.fetch(:race_ethnicity).to_sym.downcase}
reading_data_for_queried_race = reading_grouped_by_race[input].group_by {|hsh| hsh.fetch(:timeframe)}

final_reading_data = reading_data_for_queried_race.each do |(k, v)|
  reading_data_for_queried_race[k] = v.each_with_object({}) do |test_data, hsh|
    hsh[:reading] = test_data.fetch(:data)
  end
end

final_writing_data = writing_data_for_queried_race.each do |(k, v)|
  writing_data_for_queried_race[k] = v.each_with_object({}) do |test_data, hsh|
    hsh[:writing] = test_data.fetch(:data), hsh[:writing] = reading_data_for_queried_race
  end
end
binding.pry
