require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/statewide_testing'
require_relative '../lib/district_repository.rb'

class TestEconomicProfile < Minitest::Test
  def test_proficient_by_grade
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes
    assert_equal "", district.statewide_testing.proficient_by_grade(3).fetch("2008"[:math])
  end
end
