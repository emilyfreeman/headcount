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
end
