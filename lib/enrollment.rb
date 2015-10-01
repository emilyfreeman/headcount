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

  def confirm_race_data(race_sym)
    race_data = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white, :all_students]
    if !race_data.any?{ |race| race == race_sym }
      raise UnknownRaceError
    end
  end

  def is_nil?(rate)
    if rate.empty?
      return nil
    else
      rate
    end
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
    years = parsed_file.map{|row| row.fetch(:timeframe).to_i}.uniq
  end

  def find_rate_by_year(file_name)
    parsed_file = parse_method_file(file_name)
    years = find_year_range(file_name)
    final = {}
    parsed_file.map{|row|
      if years.include?(row[:timeframe].to_i)
        final[row[:timeframe].to_i] = truncate_floats(row[:data])
      end
    }
    final.sort.to_h
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

  def format_race_categories(string)
    string.split.delete_if{|word| (word == "Students") || (word.downcase == "races")}.join("_").downcase.gsub("native_hawaiian_or_other_pacific_islander", "pacific_islander").gsub("american_indian", "native_american").to_sym
  end

  def dropout_rate_by_category(year)
    filename = "Dropout rates by race and ethnicity.csv"
    parsed_file = parse_method_file(filename)
    categories = {}
    parsed_file.each do |row|
      if row.fetch(:dataformat) == "Percent" && row.fetch(:timeframe) == "#{year}"
        categories[format_race_categories(row.fetch(:category))] = truncate_floats(row.fetch(:data))
      end
    end
    categories
  end

  def dropout_rate_by_gender_in_year(year)
    rate = dropout_rate_by_category(year).select{|k,v| (k == :female || k == :male)}
    is_nil?(rate)
  end

  def dropout_rate_by_race_in_year(year)
    rate = dropout_rate_by_category(year).select{|k,v| (k != :female && k != :male && k != :all)}
    is_nil?(rate)
  end

  def dropout_rate_for_race_or_ethnicity(race)
    confirm_race_data(race)
    years = find_year_range("Dropout rates by race and ethnicity.csv")
    final = {}
    years.each do |year|
      final[year] = dropout_rate_by_category(year).select{|k,v| k == race}.values.first
    end
    final

  end

  def dropout_rate_for_race_or_ethnicity_in_year(race, year)
    confirm_race_data(race)
    dropout_rate_for_race_or_ethnicity(race)[year]
  end

  def graduation_rate_by_year
    find_rate_by_year("High school graduation rates.csv")
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

  def kindergarten_participation_by_year
    find_rate_by_year("Kindergartners in full-day program.csv")
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def online_participation_by_year
    find_rate_by_year("Online pupil enrollment.csv")
  end

  def online_participation_in_year(year)
    if online_participation_by_year[year]
      online_participation_by_year[year].to_i
    end
  end

  def participation_by_year
    find_number_by_year("Pupil enrollment.csv")
  end

  def participation_in_year(year)
    participation_by_year[year]
  end

  def participation_by_race_or_ethnicity_in_year(year)
    filename = "Pupil enrollment by race_ethnicity.csv"
    parsed_file = parse_method_file(filename)
    categories = {}
    parsed_file.each do |row|
      if row.fetch(:dataformat) == "Percent" && row.fetch(:timeframe) == "#{year}" && row.fetch(:race) != "Total"
        categories[format_race_categories(row[:race])] = truncate_floats(row.fetch(:data))
      end
    end
    unless categories.empty?
    categories
  end
  end

  def participation_by_race_or_ethnicity(race)
    confirm_race_data(race)
    years = find_year_range("Pupil enrollment by race_ethnicity.csv")
    final = {}
    years.each do |year|
      final[year] = participation_by_race_or_ethnicity_in_year(year).select{|k,v| k == race}.values.first
    end
    final
  end

  def special_education_by_year
    find_rate_by_year("Special education.csv")
  end

  def special_education_in_year(year)
    special_education_by_year[year]
  end

  def remediation_by_year
    find_rate_by_year("Remediation in higher education.csv")
  end

  def remediation_in_year(year)
    remediation_by_year[year]
  end

end
