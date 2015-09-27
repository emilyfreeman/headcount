require_relative 'parse'
require 'pry'

class Enrollment

  def initialize(district_name)
    @district_name = district_name
  end

  def parse_method_file(filename)
    @parsed_file ||= Parse.new(@district_name, filename).parse_runner
  end

  def truncate_floats(str)
    str.to_s[0..4].to_f
  end

  def dropout_rate_in_year(year)
    filename = "Dropout rates by race and ethnicity.csv"
    parsed_file = parse_method_file(filename)
    data = {}
    parsed_file.each do |row|
      if row.fetch(:category) == "All Students" && row.fetch(:dataformat) == "Percent"
        data[row.fetch(:timeframe).to_i] = truncate_floats(row[:data])
      end
    end
    data[year]
  end

  def find_year_range(filename)
    parsed_file = parse_method_file(filename)
    years = []
    parsed_file.each do |row|
      if !years.include?(row.fetch(:timeframe))
        years << (row.fetch(:timeframe).to_i)
      end
    end
      years
  end

  def dropout_rate_by_category(year)
    filename = "Dropout rates by race and ethnicity.csv"
    parsed_file = parse_method_file(filename)
    categories = {}
    parsed_file.each do |row|
      if row.fetch(:dataformat) == "Percent" && row.fetch(:timeframe) == "#{year}"
        categories[(row.fetch(:category)).split.delete_if{|word| (word == "Students") || (word == "Races")}.join("_").downcase.gsub("native_hawaiian_or_other_pacific_islander", "pacific_islander").to_sym] = truncate_floats(row.fetch(:data))
      end
    end
    categories
  end

  def dropout_rate_by_gender_in_year(year)
    dropout_rate_by_category(year).select{|k,v| (k == :female || k == :male)}
  end

  def dropout_rate_by_race_in_year(year)
    dropout_rate_by_category(year).select{|k,v| (k != :female && k != :male && k != :all)}
  end

  def dropout_rate_for_race_or_ethnicity(race)
    years = find_year_range("Dropout rates by race and ethnicity.csv")
    final = {}
    years.each do |year|
      final[year] = dropout_rate_by_category(year).select{|k,v| k == race}.values.first
    end
    final
  end

  def dropout_rate_for_race_or_ethnicity_in_year(race, year)
    dropout_rate_for_race_or_ethnicity(race).fetch(year)
  end

  def graduation_rate_by_year
    file_name = "High school graduation rates.csv"
    parsed_file = parse_method_file(file_name)
    years = find_year_range(file_name)
    final = {}
    parsed_file.map{|row|
      if years.include?(row[:timeframe].to_i)
        final[row[:timeframe].to_i] = truncate_floats(row[:data])
      end
    }
    final
  end

end
