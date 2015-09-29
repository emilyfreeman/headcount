require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class TestHeadcountAnalyst < Minitest::Test

  def test_statewide_testing_year_over_year_find_single_leader
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    ha = HeadcountAnalyst.new(repository)
    assert_equal 0.0, ha.top_statewide_testing_year_over_year_growth(3, :math)
  end

end
