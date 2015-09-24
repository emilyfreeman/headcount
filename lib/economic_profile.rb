require_relative 'parse'
require 'pry'

class EconomicProfile

    def initialize(district_name)
      @district_name = district_name
    end

    def free_or_reduced_lunch_by_year
      # This method returns a hash with years as keys and an floating point three-significant digits representing a percentage.
      # looks in our created hash for key "proficient by grade"
      # does calculations
      filename = "Students qualifying for free or reduced price lunch.csv"
      parsed_file = Parse.new(@district_name, filename).parse_runner
      # binding.pry
      data = {}
      parsed_file.each do |row|
        if row.fetch(:poverty_level) == "Eligible for Free or Reduced Lunch" && row.fetch(:dataformat) == "Percent"
          data[row.fetch(:timeframe)] = row[:data].to_s[0..4].to_f
        end
        binding.pry
      end
      data
    end

    def free_or_reduced_lunch_in_year(year)
      years = free_or_reduced_lunch_by_year
      years.fetch("#{year}")
    end

end
