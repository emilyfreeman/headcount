require 'csv'
require_relative 'parse'
# Pseudocode
  # Notes:
    # Actually rethinking the giant hash. I think Torie's version of having each "instance" of a district create it's own hashes might be better.

  class DistrictRepository
    def self.from_csv(path)
      # opens one csv in folder
      filename = "Students qualifying for free or reduced price lunch.csv"
      fullpath = File.join(path, filename)
      @repository = {}
      # pushes it into parser
      rows = CSV.read(fullpath, headers: true, header_converters: :symbol).each do |row|
        # only push unique names into our hash and have them point to its instance of District
        if !@repository.include?(row[:location])
          @repository[row[:location]] = District.new(row[:location])
        end
      end
      # returns hash containing just district names as strings
      # binding.pry
      self
    end

    def self.find_by_name(name)
      # searches returned hash above for district name; receives string; - returns instance of district
      if @repository.keys.include? name
        return @repository[name]
      else
        nil
      end
    end

  end


  class District
    # calls instances of "economic profile ", "enrollment" and "statewide_testing" with argument of district name
    attr_accessor :district_name

    def initialize(district_name)
      @district_name = district_name
    end

    def economic_profile
      econ = EconomicProfile.new(district_name)
    end

  end

class EconomicProfile

    def initialize(district_name)
      @district_name = district_name
    end

    def free_or_reduced_lunch_by_year
      # This method returns a hash with years as keys and an floating point three-significant digits representing a percentage.
      # looks in our created hash for key "proficient by grade"
      # does calculations
      filename = "Students qualifying for free or reduced price lunch.csv"
      parsed_file = Parse.new(@district_name, filename).parse_runner
      # binding.pry
    end


    # => { 2000 => 0.020,
    #      2001 => 0.024,
    #      2002 => 0.027,
    #      2003 => 0.030,
    #      2004 => 0.034,
    #      2005 => 0.058,
    #      2006 => 0.041,
    #      2007 => 0.050,
    #      2008 => 0.061,
    #      2009 => 0.070,
    #      2010 => 0.079,
    #      2011 => 0.084,
    #      2012 => 0.125,
    #      2013 => 0.091,
    #      2014 => 0.087,
    #    }

    def free_or_reduced_lunch_in_year(year)
      # looks in our created hash for key "proficient by grade"
      # does calculations

    end

  # etc...

end
#
# path       = File.expand_path("../data", __dir__)
# repository = DistrictRepository.from_csv(path)
# puts repository.inspect
