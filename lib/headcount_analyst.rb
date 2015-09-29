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

  def top_statewide_testing_year_over_year_growth(grade, subject)
    confirm_grade_data(grade)
    grade_data_by_district = @dr.map do |name, instance|
      parsed_file = parser(name, choose_data_for_testing_scores(grade))
    end
    grade_data_by_district.map.group_by {|data| data.fetch(:location)}

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

end
