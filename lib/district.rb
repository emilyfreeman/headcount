require_relative 'economic_profile'
require_relative 'statewide_testing'
require_relative 'enrollment'

require 'pry'
#top of data hierarchy; methods: name, statewide_testing, enrollment

  class District
    # calls instances of "economic profile ", "enrollment" and "statewide_testing" with argument of district name
    attr_accessor :name

    def initialize(district_name)
      @name = district_name
    end

    def economic_profile
      econ = EconomicProfile.new(district_name)
    end

    def statewide_testing
      econ = StatewideTesting.new(district_name)
    end

    def enrollment
      enrollment = Enrollment.new(district_name)
    end

  end
