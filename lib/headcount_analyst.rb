require_relative 'district_repository'
require_relative 'statewide_testing'
require_relative 'parse'

class HeadcountAnalyst

  def initialize(dr=DistrictRepository.new)
    @dr = dr.from_csv(File.expand_path("../data", __dir__)).repository_holder
  end

  def parser(district_name, filename)
    Parse.new(district_name, filename).parse_runner
  end

  def confirm_grade_data(grade_num)
    grade_data = [3, 8]
    if !grade_data.any?{ |input| input == grade_num }
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

  def truncate_floats(num)
    num.to_s[0..4].to_f
  end

  def create_weighted_math_hsh(grade, weighting, top)
    math_hsh = growth_hash_for_all_districts_by_subject(grade, top, :math)
    weighted_math = math_hsh.map {|hsh| hsh.each {|k, v| hsh[k] =  v * weighting[:weighting][:math]} }
  end

  def create_weighted_reading_hsh(grade, weighting, top)
    reading_hsh = growth_hash_for_all_districts_by_subject(grade, top, :reading)
    reading_hsh.map {|hsh| hsh.each {|k, v| hsh[k] =  v * weighting[:weighting][:reading]} }
  end

  def create_weighted_writing_hsh(grade, weighting, top)
    writing_hsh = growth_hash_for_all_districts_by_subject(grade, top, :writing)
    weighted_writing = writing_hsh.map {|hsh| hsh.each {|k, v| hsh[k] =  v * weighting[:weighting][:writing]} }
  end

  def merge_weighted_hshs(weighted_reading, weighted_math, weighted_writing)
    two_subjects = weighted_math.zip(weighted_reading)
    weighted_hsh_all_subjects = two_subjects.zip(weighted_writing)
    flattened_weighted_hsh = weighted_hsh_all_subjects.flatten
    merge_subject_hashes_into_one(flattened_weighted_hsh, averages={})
  end

  def top_statewide_testing_year_over_year_growth_weighted(grade, weighting, top = 1)
    weighted_math = create_weighted_math_hsh(grade, weighting, top)
    weighted_reading = create_weighted_reading_hsh(grade, weighting, top)
    weighted_writing = create_weighted_writing_hsh(grade, weighting, top)

    weighted_scores = merge_weighted_hshs(weighted_reading, weighted_math, weighted_writing)

    avg_value = average(weighted_scores)
    sort_by_top_value(avg_value, top)
  end

  def top_statewide_testing_year_over_year_growth(grade, subject=:all_subjects, top=1)
    confirm_grade_data(grade)
    if subject != :all_subjects
      find_top_performers(grade, top, subject)
    else
      create_avg_for_all_subjects(grade, top)
    end
  end

  def create_3_subject_hash(grade, top=1)
    math_hsh = growth_hash_for_all_districts_by_subject(grade, top, :math)
    reading_hsh = growth_hash_for_all_districts_by_subject(grade, top, :reading)
    writing_hsh = growth_hash_for_all_districts_by_subject(grade, top, :writing)
    two_subjects = math_hsh.zip(reading_hsh)
    two_subjects.zip(writing_hsh)
  end

  def merge_subject_hashes_into_one(subject_hsh, averages={})
    subject_hsh.each do |item|
        key, value = item.flatten
        if averages[key].nil?
          averages[key] = []
        end
        averages[key] << value
    end
    averages
  end

  def average(data)
    data.each do |key,value|
      data[key] = truncate_floats(value.reduce(&:+) / value.size)
    end
  end

  def create_avg_for_all_subjects(grade, top, weight=1)
    subject_hsh = create_3_subject_hash(grade, top)
    flattened = subject_hsh.flatten
    data = merge_subject_hashes_into_one(flattened)
    avg_value = average(data)
    sort_by_top_value(avg_value, top)
  end

  def growth_hash_for_all_districts_by_subject(grade, top, subject)
    @dr.map do |name, instance|
      parsed_file_for_district = parser( name, choose_data_for_testing_scores(grade) )
      data_by_subject = parsed_file_for_district.group_by { |data| data[:score].downcase.to_sym }
      data_by_year = data_by_subject[subject.downcase.to_sym].group_by { |hsh| hsh[:timeframe].to_i }
      growth_over_time = find_growth_float(data_by_year)
      growth_hash = { name => truncate_floats(growth_over_time) }
    end
  end

  def find_top_performers(grade, top, subject)
    grade_data_by_district = growth_hash_for_all_districts_by_subject(grade, top, subject)
    one_hash = grade_data_by_district.inject(&:merge)
    sort_by_top_value(one_hash, top)
  end

  def sort_by_top_value(hsh, top)
    output = hsh.sort_by {|k, v| -v}.first(top)
    output.flatten
  end

  def find_growth_float(data)
    ( ( (data.fetch(2014)[0][:data].to_f) - (data.fetch(2013)[0][:data].to_f) ) +
      ( (data.fetch(2013)[0][:data].to_f) - (data.fetch(2012)[0][:data].to_f) ) +
      ( (data.fetch(2012)[0][:data].to_f) - (data.fetch(2011)[0][:data].to_f) ) +
      ( (data.fetch(2011)[0][:data].to_f) - (data.fetch(2010)[0][:data].to_f) ) +
      ( (data.fetch(2010)[0][:data].to_f) - (data.fetch(2009)[0][:data].to_f) ) +
      ( (data.fetch(2009)[0][:data].to_f) - (data.fetch(2008)[0][:data].to_f) ) / 6 )
  end

  def confirm_district(district_name)
    if !@dr.include?(district_name)
      raise UnknownDataError
    end
  end

  def kindergarten_participation_rate_variation(school_one, school_two)
    confirm_district(school_one)
    confirm_district(school_two[:against])
    school_one_participation = find_participation_average(@dr[school_one].enrollment.kindergarten_participation_by_year)
    school_two_participation = find_participation_average(@dr[(school_two[:against])].enrollment.kindergarten_participation_by_year)
    truncate_floats(school_one_participation/school_two_participation)
  end

  def find_participation_average(participation_by_year)
    total = participation_by_year.values.length.to_f
    sum = (participation_by_year.values.inject(0){|sum, i| sum + i})
    sum/total
  end

  def kindergarten_participation_against_household_income(district_name)
    kindergarten_participation_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    median_income_variation = median_income_variation(district_name, :against => "COLORADO")
    truncate_floats(kindergarten_participation_variation/ median_income_variation)
  end

  def median_income_variation(school_one, school_two)
    school_one_participation = find_participation_average(@dr[school_one].economic_profile.median_income_by_year)
    school_two_participation = find_participation_average(@dr[(school_two[:against])].economic_profile.median_income_by_year)
    school_one_participation/school_two_participation
  end

  def evaluate_correlation(variation)
    if (variation > 0.6) && (variation < 1.5)
      return true
    else
      false
    end
  end

  def kindergarten_participation_correlates_with_household_income(district_name)
    if district_name.keys.include?(:for)
      evaluate_correlation(kindergarten_participation_against_household_income(district_name[:for]))
    else
      districts = district_name[:across].length
      average_variation = (district_name[:across].inject(0){|sum, district| kindergarten_participation_against_household_income(district) + sum})/ districts
      evaluate_correlation(average_variation)
    end
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_participation_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    graduation_rate_variation = graduation_rate_variation(district_name)
    truncate_floats(kindergarten_participation_variation/ graduation_rate_variation)
  end

  def graduation_rate_variation(school_one)
    school_one_participation = find_participation_average(@dr[school_one].enrollment.graduation_rate_by_year)
    school_two_participation = find_participation_average(@dr["COLORADO"].enrollment.graduation_rate_by_year)
    school_one_participation/school_two_participation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_name)
    if district_name.keys.include?(:for)
      evaluate_correlation(kindergarten_participation_against_high_school_graduation(district_name[:for]))
    else
      districts = district_name[:across].length
      average_variation = (district_name[:across].inject(0){|sum, district| kindergarten_participation_against_high_school_graduation(district) + sum})/ districts
      evaluate_correlation(average_variation)
    end
  end

end
