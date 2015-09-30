require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class TestHeadcountAnalyst < Minitest::Test

  # def test_statewide_testing_year_over_year_find_single_leader
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 0.0, ha.top_statewide_testing_year_over_year_growth(3, :math)
  # end

  # def test_statewide_testing_year_over_year_find_avg_in_all_subjects
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 0.0, ha.top_statewide_testing_year_over_year_growth(3)
  # end
  #
  # def test_year_over_year_growth_wiley_re
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 0.0, ha.top_statewide_testing_year_over_year_growth(3, :math)
  # end

  def test_year_over_year_growth_with_subject_weighting
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    ha = HeadcountAnalyst.new(repository)
    assert_equal 0.0, ha.top_statewide_testing_year_over_year_growth(3, :math)
  end

:weighting => {:math = 0.5, :reading => 0.5, :writing => 0.0}
  # def test_kindergarten_participation_comparison_to_state
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 0.766,ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  # end
  #
  # def test_kindergarten_participation_comparison_to_itself_returns_one
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 1.0, ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ACADEMY 20')
  # end
  #
  # def test_kindergarten_participation_comparison_to_other_district
  #   path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
  #   repository = DistrictRepository.from_csv(path) # repository almost means a search engine
  #   ha = HeadcountAnalyst.new(repository)
  #   assert_equal 0.406, ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ASPEN 1')
  # end
#
#   def test_it_compares_median_income_variation_to_kindergarten_participation_variation
#     path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
#     repository = DistrictRepository.from_csv(path) # repository almost means a search engine
#     ha = HeadcountAnalyst.new(repository)
#     assert_equal 0.501, ha.kindergarten_participation_against_household_income('ACADEMY 20')
#     assert_equal 1.631, ha.kindergarten_participation_against_household_income('ASPEN 1')
#     assert_equal 1.282, ha.kindergarten_participation_against_household_income('DEL NORTE C-7')
#   end
#
#   def test_it_evaluates_correlation
#     path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
#     repository = DistrictRepository.from_csv(path) # repository almost means a search engine
#     ha = HeadcountAnalyst.new(repository)
#     assert_equal false, ha.kindergarten_participation_correlates_with_household_income(for: 'AGUILAR REORGANIZED 6')
# # `    assert_equal false, ha.kindergarten_participation_correlates_with_household_income(for: 'COLORADO')
#   end
#
#   def test_it_evaluates_correlation_across_districts
#     path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
#     repository = DistrictRepository.from_csv(path) # repository almost means a search engine
#     ha = HeadcountAnalyst.new(repository)
#     assert_equal false, ha.kindergarten_participation_correlates_with_household_income(:across => ['ACADEMY 20', 'YUMA SCHOOL DISTRICT 1', 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
#   end
#
#   def test_it_evaluates_correlation_of_kindergarten_participation_with_high_school_graduation
#     path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
#     repository = DistrictRepository.from_csv(path) # repository almost means a search engine
#     ha = HeadcountAnalyst.new(repository)
#     assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
#     assert_equal 0.222, ha.kindergarten_participation_against_high_school_graduation('CHERRY CREEK 5')
#   end
#
#   def test_it_evaluates_correlation_across_districts_for_graduation_rates
#     path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
#     repository = DistrictRepository.from_csv(path) # repository almost means a search engine
#     ha = HeadcountAnalyst.new(repository)
#     assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'CHERRY CREEK 5')
#     assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ARICKAREE R-2')
#   end
end
