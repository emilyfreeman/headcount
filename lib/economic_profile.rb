require_relative 'parse'
require 'pry'

class EconomicProfile

    def initialize(district_name)
      @district_name = district_name
    end

    def free_or_reduced_lunch_by_year
      filename = "Students qualifying for free or reduced price lunch.csv"
      parsed_file = Parse.new(@district_name, filename).parse_runner
      data = {}
      parsed_file.each do |row|
        if row.fetch(:poverty_level) == "Eligible for Free or Reduced Lunch" && row.fetch(:dataformat) == "Percent"
          data[row.fetch(:timeframe).to_i] = row[:data].to_s[0..4].to_f
        end
      end
      data
    end

    def free_or_reduced_lunch_in_year(year)
      if free_or_reduced_lunch_by_year[year]
        free_or_reduced_lunch_by_year.fetch(year)
      else
        nil
      end
    end

    def school_aged_children_in_poverty_by_year
      filename = "School-aged children in poverty.csv"
      parsed_file = Parse.new(@district_name, filename).parse_runner
      data = {}
      parsed_file.each do |row|
        if row.fetch(:dataformat) == "Percent"
          data[row.fetch(:timeframe).to_i] = row[:data].to_s[0..4].to_f
        end
      end
      data
    end

    def school_aged_children_in_poverty_in_year(year)
      if school_aged_children_in_poverty_by_year[year]
        return school_aged_children_in_poverty_by_year.fetch(year)
      else
        return nil
      end
    end

    def title_1_students_by_year

    end


end
