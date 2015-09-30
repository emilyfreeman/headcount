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

  def top_statewide_testing_year_over_year_growth(grade, top=1, subject)
    confirm_grade_data(grade)
    growth_hash_for_all_districts_by_subject(grade, top, subject)
  end

  def growth_hash_for_all_districts_by_subject(grade, top, subject)
    grade_data_by_district = @dr.map do |name, instance|
      parsed_file_for_district = parser( name, choose_data_for_testing_scores(grade) )
      b = parsed_file_for_district.group_by { |data| data[:score].downcase.to_sym }
      c = b[subject.downcase.to_sym].group_by { |hsh| hsh[:timeframe].to_i }
      growth_over_time = find_growth_float(c)
      growth_hash = { name => truncate_floats(growth_over_time) }
    end
    one_hash = grade_data_by_district.inject(&:merge)
    one_hash.sort_by {|k, v| -v}.first(top)
  end

  def find_growth_float(c)
    ( ( (c.fetch(2014)[0][:data].to_f) - (c.fetch(2013)[0][:data].to_f) ) +
      ( (c.fetch(2013)[0][:data].to_f) - (c.fetch(2012)[0][:data].to_f) ) +
      ( (c.fetch(2012)[0][:data].to_f) - (c.fetch(2011)[0][:data].to_f) ) +
      ( (c.fetch(2011)[0][:data].to_f) - (c.fetch(2010)[0][:data].to_f) ) +
      ( (c.fetch(2010)[0][:data].to_f) - (c.fetch(2009)[0][:data].to_f) ) +
      ( (c.fetch(2009)[0][:data].to_f) - (c.fetch(2008)[0][:data].to_f) ) / 6 )
  end


  #   end
  #     statewide_testing = instance.statewide_testing
  #     filename = statewide_testing.choose_data_for_testing_scores(grade)
  #     parsed_file = statewide_testing.parser(filename)
  #     statewide_testing.confirm_grade_data(grade)
  #   "something"
  #   #x find highest
  # end

end
