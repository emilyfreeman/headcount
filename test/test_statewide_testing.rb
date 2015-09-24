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
    assert_equal 0.857, district.statewide_testing.proficient_by_grade(3)["2008"][:math]
  end

  def test_proficient_by_grade_diff_district
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("KIOWA C-2") # can make header in CSV file the keys of the hashes
    assert_equal 0.875, district.statewide_testing.proficient_by_grade(3)["2008"][:math]
  end

  def test_proficient_by_grade_diff_subject
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes
    assert_equal 0.866, district.statewide_testing.proficient_by_grade(3)["2008"][:reading]
  end

  def test_proficient_by_grade_diff_district_and_diff_grade
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("KIOWA C-2") # can make header in CSV file the keys of the hashes
    assert_equal 0.615, district.statewide_testing.proficient_by_grade(8)["2008"][:math]
  end

  def test_proficient_by_race_or_ethnicity
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes
    assert_equal nil, district.statewide_testing.proficient_by_race_or_ethnicity("black")

  end

  def test_proficient_for_subject_by_grade_in_year
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes
    assert_equal 0.849, district.statewide_testing.proficient_for_subject_by_grade_in_year(:math, 3, 2010)
  end

  def test_proficient_for_subject_by_grade_in_year_diff_district
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("KIOWA C-2") # can make header in CSV file the keys of the hashes
    assert_equal 0.24, district.statewide_testing.proficient_for_subject_by_grade_in_year(:writing, 3, 2011)
  end

end
