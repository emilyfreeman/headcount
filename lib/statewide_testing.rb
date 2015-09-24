require_relative 'parse'
require 'pry'

class StatewideTesting

  def initialize(district_name)
    @district_name = district_name
  end

  # def free_or_reduced_lunch_by_year

  # end

  def truncate_floats(str)
    str.to_s[0..4].to_f
  end

  def choose_data_for_testing_scores(grade)
    if grade == 3
      filename = "3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    elsif grade == 8
      filename = "8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    else
      raise "WTF? You need a UnknownDataError class"
    end
  end

  def proficient_by_grade(grade)
    # grade is an integer; either 3 or 8
    # unknown grade should raise a UnknownDataError
    # The method returns a hash grouped by year referencing percentages by subject all as three digit floats.
    filename = choose_data_for_testing_scores(grade)
    parsed_file = Parse.new(@district_name, filename).parse_runner
    statewide_by_date = parsed_file.group_by {|hsh| hsh.fetch(:timeframe)}
    statewide_by_date.each {|(k,v)| statewide_by_date[k] = v.each_with_object({}) {|score, hsh| hsh[(score[:score]).to_sym.downcase] = truncate_floats(score[:data])}}
  end


  def proficient_by_race_or_ethnicity(race)
  # race as a symbol from the following set: [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  # A call to this method with an unknown race should raise a UnknownDataError.
  # The method returns a hash grouped by race referencing percentages by subject all as truncated three digit floats.

  # statewide_testing.proficient_by_race_or_ethnicity(:asian)
  # # => { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
  # #      2012 => {math: 0.818, reading: 0.893, writing: 0.808},
  # #    }

  end







  def proficient_for_subject_by_grade_in_year(subject, grade, year)
  #
  # This method takes three parameters:
  #
  # subject as a symbol from the following set: [:math, :reading, :writing]
  # grade as an integer from the following set: [3, 8]
  # year as an integer for any year reported in the data
  # A call to this method with any invalid parameter (like subject of :science) should raise a UnknownDataError.
  #
  # The method returns a truncated three-digit floating point number representing a percentage.
  #
  # Example:
  #
  # statewide_testing.proficient_for_subject_by_grade_in_year(:math, 3, 2008) # => 0.857
  #
  end
  def proficient_for_subject_by_race_in_year(subject, race, year)
  #
  # This method take three parameters:
  #
  # subject as a symbol from the following set: [:math, :reading, :writing]
  # race as a symbol from the following set: [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  # year as an integer for any year reported in the data
  # A call to this method with any invalid parameter (like subject of :history) should raise a UnknownDataError.
  #
  # The method returns a truncated three-digit floating point number representing a percentage.
  #
  # Example:
  #
  # statewide_testing.proficient_for_subject_by_race_in_year(:math, :asian, 2012) # => 0.818
  end
  def proficient_for_subject_in_year(subject, year)
  #
  # This method take two parameters:
  #
  # subject as a symbol from the following set: [:math, :reading, :writing]
  # year as an integer for any year reported in the data
  # A call to this method with any invalid parameter (like subject of :history) should raise a UnknownDataError.
  #
  # The method returns a truncated three-digit floating point number representing a percentage.
  #
  # Example:
  #
  # statewide_testing.proficient_for_subject_in_year(:math, 2012) # => 0.680
  end




end
