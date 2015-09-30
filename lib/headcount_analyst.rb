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

  def top_statewide_testing_year_over_year_growth(grade, subject=:all_subjects, top=1)
    confirm_grade_data(grade)
    if subject != :all_subjects
      find_top_performers(grade, top, subject)
    else
      create_avg_for_all_subjects(grade, top, weight=1)
    end
  end

  def create_avg_for_all_subjects(grade, top, weight=1)
    math_hsh = growth_hash_for_all_districts_by_subject(grade, top, :math)
    reading_hsh = growth_hash_for_all_districts_by_subject(grade, top, :reading)
    writing_hsh = growth_hash_for_all_districts_by_subject(grade, top, :writing)
    two_subjects = math_hsh.zip(reading_hsh)
    subject_hsh = two_subjects.zip(writing_hsh)
    binding.pry
  end

  def average_values
    self.reduce(&:+) / self.size
  end

# r = a[0].keys.map do |key|
#   [key, a.map { |hash| hash[key] }.average]
# end
#
# puts Hash[*r.flatten]
# end

  def growth_hash_for_all_districts_by_subject(grade, top, subject)
    @dr.map do |name, instance|
      parsed_file_for_district = parser( name, choose_data_for_testing_scores(grade) )
      b = parsed_file_for_district.group_by { |data| data[:score].downcase.to_sym }
      c = b[subject.downcase.to_sym].group_by { |hsh| hsh[:timeframe].to_i }
      growth_over_time = find_growth_float(c)
      growth_hash = { name => truncate_floats(growth_over_time) }
    end
  end

  def find_top_performers(grade, top, subject)
    grade_data_by_district = growth_hash_for_all_districts_by_subject(grade, top, subject)
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

end
