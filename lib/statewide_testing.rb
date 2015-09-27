require_relative 'parse'
require 'pry'

class StatewideTesting

  def initialize(district_name)
    @district_name = district_name
  end

  def truncate_floats(str)
    str.to_s[0..4].to_f
  end

  def parser(filename)
    Parse.new(@district_name, filename).parse_runner
  end

  def choose_data_for_testing_scores(grade)
    if grade == 3
      "3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    elsif grade == 8
      "8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    else
      raise "WTF? You need a UnknownDataError class"
    end
  end

  def proficient_by_grade(grade)
    # grade is an integer; either 3 or 8
    # unknown grade should raise a UnknownDataError
    # The method returns a hash grouped by year referencing percentages by subject all as three digit floats.
    parsed_file = parser(choose_data_for_testing_scores(grade))

    statewide_by_date = parsed_file.group_by {|hsh| hsh.fetch(:timeframe).to_i}
    statewide_by_date.each { |(k,v)| statewide_by_date[k] = v.each_with_object({}) { |score, hsh| hsh[ ( score[:score] ).to_sym.downcase ] = truncate_floats( score[:data] ) } }
  end

  def filter_scores_on_race(scores, input)
    scores.select { |score| score[:race_ethnicity].to_sym.downcase == input }
  end

  def retrieve_race_based_reading_scores(sym)
    parsed_reading_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv" )
    filter_scores_on_race( parsed_reading_scores, sym )
  end

  def retrieve_race_based_writing_scores(sym)
    parsed_writing_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv" )
    filter_scores_on_race( parsed_writing_scores, sym )
  end

  def retrieve_race_based_math_scores(sym)
    parsed_math_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv" )
    filter_scores_on_race( parsed_math_scores, sym )
  end

  def create_case_insensitive_symbol(str)
    str.to_sym.downcase
  end

  def proficient_by_race_or_ethnicity(queried_race)
    input = create_case_insensitive_symbol(queried_race)

    filtered_reading_scores = retrieve_race_based_reading_scores(input)
    filtered_writing_scores = retrieve_race_based_writing_scores(input)
    filtered_math_scores = retrieve_race_based_math_scores(input)

    mapped_reading = filtered_reading_scores.map { |score| {score[:timeframe] => {reading: score[:data]}} }
    mapped_math = filtered_math_scores.map { |score| {score[:timeframe] => {math: score[:data]}} }
    create_reading_writing_math_scores_by_race(filtered_writing_scores, mapped_reading, mapped_math)
  end

  def create_reading_writing_math_scores_by_race(filtered_writing_scores, mapped_reading, mapped_math, mapped={})
    filtered_writing_scores.each do |score|
      mapped[ score[:timeframe].to_i ] = {
          writing: truncate_floats( score[:data] ),
          reading: mapped_reading.select { |r| r.has_key?( score[:timeframe] ) }[0][score[:timeframe]][:reading].to_s[0..4].to_f,
          math: mapped_math.select { |r| r.has_key?( score[:timeframe] ) }[0][score[:timeframe]][:math].to_s[0..4].to_f
      }
    end
    mapped
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    # The method returns a truncated three-digit floating point number representing a percentage.
    parsed_file = parser(choose_data_for_testing_scores(grade))
    grouped_data_by_subject = parsed_file.group_by {|hsh| hsh.fetch(:score).to_sym.downcase}
    queried_subject_data = grouped_data_by_subject[subject].group_by {|hsh| hsh.fetch(:timeframe).to_i}
    truncate_floats(queried_subject_data[year][0].fetch(:data))
  end

  def proficient_for_subject_by_race_in_year(subject, queried_race, year)
    # This method take three parameters: subject as symbol; race as symbol; year as integer
    # The method returns a truncated three-digit floating point number representing a percentage.
    input = create_case_insensitive_symbol(queried_race)
    mapped = proficient_by_race_or_ethnicity(input)
    mapped.fetch(year)[subject]
  end

  def proficient_for_subject_in_year(subject, year)
  # This method take two parameters: subject as symbol; year as integer
    proficient_for_subject_by_race_in_year(subject, queried_race="All Students", year)

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
