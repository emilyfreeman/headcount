require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/district_repository'

class TestEnrollment < Minitest::Test

  def test_it_finds_dropout_rate_in_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal 0.004, district.enrollment.dropout_rate_in_year(2012)
  end

  def test_it_returns_nil_for_year_not_in_system
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal nil, district.enrollment.dropout_rate_in_year(2032)
  end

  def test_it_compiles_categories_for_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("AKRON R-1")
    assert_equal ({:all => 0.011, :female => 0.021, :male => 0.000, :native_american => 0.000, :asian => 0.000, :black => 0.000, :hispanic => 0.040, :white => 0.006, :pacific_islander => 0.000, :two_or_more => 0.00}), district.enrollment.dropout_rate_by_category(2011)
  end

  def test_it_returns_dropout_rate_for_males_and_females_in_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("AKRON R-1")
    assert_equal ({:female => 0.021, :male => 0.000}), district.enrollment.dropout_rate_by_gender_in_year(2011)
  end

  def test_it_returns_dropout_rate_for_race_for_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("AGATE 300")
    assert_equal ({:native_american => 0.000, :asian => 0.000, :black => 0.000, :hispanic => 0.000, :white => 0.125, :pacific_islander => 0.000, :two_or_more => 0.00}), district.enrollment.dropout_rate_by_race_in_year(2012)
  end

  def test_it_returns_dropout_rates_for_race_by_years
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("AKRON R-1")
    assert_equal ({2011 => 0.000, 2012 => 0.000}), district.enrollment.dropout_rate_for_race_or_ethnicity(:asian)
  end

  def test_it_returns_dropout_rate_for_one_race_in_one_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("AKRON R-1")
    assert_equal 0.00, district.enrollment.dropout_rate_for_race_or_ethnicity_in_year(:asian, 2012)
  end

  def test_it_graduation_rate_by_year
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ADAMS COUNTY 14")
    assert_equal ({2010 => 0.570, 2011 => 0.608, 2012 => 0.633, 2013 => 0.593, 2014 => 0.659}), district.enrollment.graduation_rate_by_year
  end

end
