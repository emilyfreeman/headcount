require 'minitest/autorun'
require 'minitest/pride'
require 'CSV'
require 'pry'


class DistrictRepository

  # receives a string
  # returns a DistrictRepository
  def self.from_csv(path) # this method should be the only self. method so that it can handle JSON data as well as CSV data
    filename = "Students qualifying for free or reduced price lunch.csv"
    fullpath = File.join(path, filename)
    rows = CSV.read(fullpath, headers: true, header_converters: :symbol).each {|row| row.to_h} # remove first
    repo_data = rows.each {|row| row[:location] = "ACADEMY 20"}
    # DistrictRepository.new(repo_data)

    # {location:
                {ACADEMY 20:
                            {
                              
                            }
                {COLORADO:




                }
  end

  def find_by_name(string)

  end

end

class TestEconomicProfile < Minitest::Test
  def test_free_or_reduced_lunch_in_year
    path = File.expand_path("../data", __dir__) # __dir__ means the directory this file is currently in. And __file__ is the current file.
    repository = DistrictRepository.from_csv(path) # repository almost means a search engine
    district = repository.find_by_name("ACADEMY 20") # can make header in CSV file the keys of the hashes

    assert_equal 0.125, district.economic_profile.free_or_reduced_lunch_in_year(2012)
  end
end
