require_relative 'parse'
require 'pry'

class Enrollment

  def initialize(district_name)
    @district_name = district_name
  end

  def dropout_rate_in_year(year)
    filename = "Dropout rates by race and ethnicity.csv"
    parsed_file = Parse.new(@district_name, filename).parse_runner
    data = {}
    parsed_file.each do |row|
      if row.fetch(:category) == "All Students" && row.fetch(:dataformat) == "Percent"
        data[row.fetch(:timeframe).to_i] = row[:data].to_s[0..4].to_f
      end
    end
    data[year]
  end

  def find_year_range(filename)
    parsed_file = Parse.new(@district_name, filename).parse_runner
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
    parsed_file = Parse.new(@district_name, filename).parse_runner
    categories = {}
    parsed_file.each do |row|
      if row.fetch(:dataformat) == "Percent" && row.fetch(:timeframe) == "#{year}"
        categories[(row.fetch(:category)).split.delete_if{|word| (word == "Students") || (word == "Races")}.join("_").downcase.gsub("native_hawaiian_or_other_pacific_islander", "pacific_islander").to_sym] = row.fetch(:data).to_s[0..4].to_f
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

end
