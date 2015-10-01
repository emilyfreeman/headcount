require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/district_repository'

class TestDistrictRepository < Minitest::Test

  def test_it_finds_hash_name
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    assert repository.find_by_name("colorado")
  end

  def test_find_by_name_is_case_insensitive
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    assert repository.find_by_name("coLOrado")
  end

  def test_it_returns_all_matching_certain_string
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    assert_equal ['COLORADO', 'COLORADO SPRINGS 11'], repository.find_all_matching("ora").map { |district| district.name }.sort
  end

  def test_all_matching_method_is_case_insensitive
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    assert_equal ['COLORADO', 'COLORADO SPRINGS 11'], repository.find_all_matching("oRAd").map { |district| district.name }.sort
  end

  def test_find_by_name_returns_instance_of_district
    path = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    assert_equal District, repository.find_by_name("coLOrado").class
  end
end
