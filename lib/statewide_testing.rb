require_relative 'parse'
require_relative 'unknown_data_error'
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

  def confirm_race_data(race_sym)
    race_data = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white, :all_students]
    if !race_data.any?{ |race| race == race_sym }
      raise UnknownRaceError
    end
  end

  def confirm_grade_data(grade_num)
    grade_data = [3, 8]
    if !grade_data.any?{ |input| input == grade_num }
      raise UnknownDataError
    end
  end

  def confirm_subject_data(subject_sym)
    subject_data = [:math, :reading, :writing]
    if !subject_data.any?{ |subject| subject == subject_sym }
      raise UnknownDataError
    end
  end

  def choose_data_for_testing_scores(grade)
    if grade == 3
      "3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    else grade == 8
      "8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    end
  end

  def proficient_by_grade(grade)
    # grade is an integer; either 3 or 8
    # unknown grade should raise a UnknownDataError
    # The method returns a hash grouped by year referencing percentages by subject all as three digit floats.
    confirm_grade_data(grade)
    parsed_file = parser(choose_data_for_testing_scores(grade))
  
    statewide_by_date = parsed_file.group_by {|hsh| hsh.fetch(:timeframe).to_i}
    statewide_by_date.each { |(k,v)| statewide_by_date[k] = v.each_with_object({}) { |score, hsh| hsh[ ( score[:score] ).to_sym.downcase ] = truncate_floats( score[:data] ) } }
  end

  def filter_scores_on_race(scores, race)
    # scores.select { |score| score[:race_ethnicity].to_sym.downcase == race }
    scores.select { |score| score[:race_ethnicity].gsub("Hawaiian/Pacific Islander", "Pacific Islander").gsub(" ", "_").to_sym.downcase == race }

  end

  def retrieve_race_based_reading_scores(sym)
    parsed_reading_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv" )
    parsed_file = filter_scores_on_race( parsed_reading_scores, sym )
  end

  def retrieve_race_based_writing_scores(sym)
    parsed_writing_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv" )
    filter_scores_on_race( parsed_writing_scores, sym )
  end

  def retrieve_race_based_math_scores(sym)
    parsed_math_scores = parser( "Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv" )
    filter_scores_on_race( parsed_math_scores, sym )
  end

  def proficient_by_race_or_ethnicity(queried_race)
    confirm_race_data(queried_race)

    filtered_reading_scores = retrieve_race_based_reading_scores(queried_race)
    filtered_writing_scores = retrieve_race_based_writing_scores(queried_race)
    filtered_math_scores = retrieve_race_based_math_scores(queried_race)

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
    confirm_grade_data(grade)
    confirm_subject_data(subject)
    parsed_file = parser(choose_data_for_testing_scores(grade))
    grouped_data_by_subject = parsed_file.group_by {|hsh| hsh.fetch(:score).to_sym.downcase}
    queried_subject_data = grouped_data_by_subject[subject].group_by {|hsh| hsh.fetch(:timeframe).to_i}
    truncate_floats(queried_subject_data[year][0].fetch(:data))
  end

  def proficient_for_subject_by_race_in_year(subject, queried_race, year)
    # This method take three parameters: subject as symbol; race as symbol; year as integer
    # The method returns a truncated three-digit floating point number representing a percentage.
    confirm_race_data(queried_race)
    confirm_subject_data(subject)
    mapped = proficient_by_race_or_ethnicity(queried_race)
    mapped.fetch(year)[subject]
  end

  def proficient_for_subject_in_year(subject, year)
  # This method take two parameters: subject as symbol; year as integer
    proficient_for_subject_by_race_in_year(subject, :all_students, year)
  end

end
