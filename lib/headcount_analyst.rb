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

  def truncate_floats(str)
    str.to_s[0..4].to_f
  end

  def choose_data_for_testing_scores(grade)
    if grade == 3
      "3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    else grade == 8
      "8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    end
  end

  def top_statewide_testing_year_over_year_growth(grade, subject)
    confirm_grade_data(grade)
    grade_data_by_district = @dr.map do |name, instance|
      parsed_file = parser(name, choose_data_for_testing_scores(grade))
    end
    grade_data_by_district.to_h
    # .map.group_by {|data| data.fetch(:location)}

    # statewide_by_date = parsed_file.group_by {|hsh| hsh.fetch(:timeframe).to_i}

  #   end
  #     statewide_testing = instance.statewide_testing
  #     filename = statewide_testing.choose_data_for_testing_scores(grade)
  #     parsed_file = statewide_testing.parser(filename)
  #     statewide_testing.confirm_grade_data(grade)
  #   "something"
  #   #x find highest
  # end
  end

  def kindergarten_participation_rate_variation(school_one, school_two)
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

end
