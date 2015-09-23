require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/district_repository'

class TestEconomicProfile < Minitest::Test

  def test_free_or_reduced_lunch_in_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal 0.125, district.economic_profile.free_or_reduced_lunch_in_year(2012)
  end

  def test_free_or_reduced_lunch_in_year_for_different_district
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("FALCON 49") # can make header in CSV file the keys of the hashes
    assert_equal 0.153, district.economic_profile.free_or_reduced_lunch_in_year(2004)
  end

  def test_can_create_hash_of_children_in_poverty_by_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal ({1995 => 0.032, 1997 => 0.035, 1999 => 0.032, 2000 => 0.031, 2001 => 0.029, 2002 => 0.033,
     2003 => 0.037, 2004 => 0.034, 2005 => 0.042, 2006 => 0.036, 2007 => 0.039, 2008 => 0.044,
     2009 => 0.047, 2010 => 0.057, 2011 => 0.059, 2012 => 0.064, 2013 => 0.048}), district.economic_profile.school_aged_children_in_poverty_by_year
  end
  def test_can_return_value_of_children_in_poverty_for_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ALAMOSA RE-11J")
    assert_equal 0.286, district.economic_profile.school_aged_children_in_poverty_in_year(2009)
  end
end
