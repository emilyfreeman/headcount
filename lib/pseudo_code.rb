# Pseudocode
  # Notes:
    # Actually rethinking the giant hash.  Matt S. sent me the starting test that Josh gave them, here:
      # class TestLoadingDistricts < Minitest::Test
        #   def test_it_can_load_a_district_from_csv_data
        #     dr = DistrictRepository.from_csv(data_dir)
        #     district = dr.find_by_name("ACADEMY 20")
        # ​
        #     assert_equal 22620, district.enrollment.in_year(2009)
        #     assert_equal 0.895, district.enrollment.graduation_rate.for_high_school_in_year(2010)
        #     assert_equal 0.857, district.statewide_testing.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
        #   end
        # end
      # I think Torie's version of having each "instance" of a district create it's own hashes might be better.

  class DistrictRepository
    def self.from_csv(path)
      # opens one csv in folder
      # pushes it into parser
      # returns hash containing just district names
    end

    def find_by_name
      # searches returned hash above for district name - returns instance of district
    end

  end


  class District
    # calls instances of "enrollment" and "statewide_testing" with argument of district name
  end


  class StatewideTesting
    def initialize(district_name)
      # takes disctrict name
      # opens all csvs related to statewide testing (we will manually list these?)***
      # returns hash containing all statewide testing data for individual school
    end

    def proficient_by_grade
      # looks in our created hash for key "proficient by grade"
      # does calculations
    end

  # etc...

end
