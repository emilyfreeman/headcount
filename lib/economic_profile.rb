require_relative 'parse'
require 'pry'

class EconomicProfile

  def initialize(district_name)
    @district_name = district_name
  end

  def parse_method_file(filename)
    @parsed_file ||= Parse.new(@district_name, filename).parse_runner
  end

  def truncate_floats(str)
    str.to_s[0..4].to_f
  end

  def find_number_by_year(file_name)
    parsed_file = parse_method_file(file_name)
    years = find_year_range(file_name)
    final = {}
    parsed_file.map{|row|
      if years.include?(row[:timeframe].to_i)
        final[row[:timeframe].to_i] = row[:data].to_i
      end
    }
    final
  end

  def free_or_reduced_lunch_by_year
    filename = "Students qualifying for free or reduced price lunch.csv"
    parsed_file = parse_method_file(filename)
    data = {}
    parsed_file.each do |row|
      if row.fetch(:poverty_level) == "Eligible for Free or Reduced Lunch" && row.fetch(:dataformat) == "Percent"
        data[row.fetch(:timeframe).to_i] = truncate_floats(row[:data])
      end
    end
    data
  end

  def find_year_range(filename)
    parsed_file = parse_method_file(filename)
    years = parsed_file.map{|row| row.fetch(:timeframe).to_i}.uniq
  end

  def find_rate_by_year(file_name)
    parsed_file = parse_method_file(file_name)
    years = find_year_range(file_name)
    final = {}
    parsed_file.map{|row|
      if years.include?(row[:timeframe].to_i) && row.fetch(:dataformat) == "Percent"
        final[row[:timeframe].to_i] = truncate_floats(row[:data])
      end
    }
    final.sort.to_h
  end

  def free_or_reduced_lunch_in_year(year)
    if free_or_reduced_lunch_by_year[year]
      free_or_reduced_lunch_by_year.fetch(year)
    else
      nil
    end
  end

  def school_aged_children_in_poverty_by_year
    find_rate_by_year("School-aged children in poverty.csv")
  end

  def school_aged_children_in_poverty_in_year(year)
    if school_aged_children_in_poverty_by_year[year]
      return school_aged_children_in_poverty_by_year.fetch(year)
    else
      return nil
    end
  end

  def title_1_students_by_year
    find_rate_by_year("Title I students.csv")
  end

  def title_1_students_in_year(year)
    if title_1_students_by_year[year]
      return title_1_students_by_year.fetch(year)
    else
      return nil
    end
  end

  def median_income_by_year
    find_number_by_year("Median household income.csv")
  end

end
