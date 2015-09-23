require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/pseudo_code'

class TestEconomicProfile < Minitest::Test
  def test_free_or_reduced_lunch_in_year
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes

    assert_equal 0.125, district.economic_profile.free_or_reduced_lunch_by_year
  end
end
