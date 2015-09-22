# Pseudocode
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
