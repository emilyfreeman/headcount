require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/district_repository'

class TestEconomicProfile < Minitest::Test
  def test_free_or_reduced_lunch_in_year
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes
    assert_equal 0.125, district.economic_profile.free_or_reduced_lunch_in_year(2012)
  end

  def test_free_or_reduced_lunch_in_year_for_different_district
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("FALCON 49") # can make header in CSV file the keys of the hashes
    assert_equal 0.153, district.economic_profile.free_or_reduced_lunch_in_year(2004)
  end
end
