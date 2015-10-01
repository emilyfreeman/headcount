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
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("FALCON 49") 
    assert_equal 0.153, district.economic_profile.free_or_reduced_lunch_in_year(2004)
  end

  def test_unknown_year_for_reduced_lunch_returns_nil
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ALAMOSA RE-11J")
    assert_equal nil, district.economic_profile.free_or_reduced_lunch_in_year(2040)
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

  def test_unknown_year_for_children_in_poverty_returns_nil
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ALAMOSA RE-11J")
    assert_equal nil, district.economic_profile.school_aged_children_in_poverty_in_year(2020)
  end

  def test_it_can_return_hash_of_title_1_students
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal({2009 => 0.014, 2011 => 0.011, 2012 => 0.01, 2013 => 0.012, 2014 => 0.027}, district.economic_profile.title_1_students_by_year)
  end

  def test_it_can_return_percentage_of_title_1_students_for_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal 0.011, district.economic_profile.title_1_students_in_year(2011)
  end

end
