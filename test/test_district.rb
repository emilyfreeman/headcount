require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'

class TestDistrict < Minitest::Test

  def test_it_carries_name_of_district
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_find_by_name_returns_instance_of_data_classes
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district = repository.find_by_name("ACADEMY 20")
    assert_equal EconomicProfile, district.economic_profile.class
    assert_equal Enrollment, district.enrollment.class
    assert_equal StatewideTesting, district.statewide_testing.class
  end

end
