require_relative 'economic_profile'
require_relative 'statewide_testing'
require_relative 'enrollment'

require 'pry'

  class District
    attr_accessor :name

    def initialize(district_name)
      @name = district_name
    end

    def economic_profile
      econ = EconomicProfile.new(name)
    end

    def statewide_testing
      econ = StatewideTesting.new(name)
    end

    def enrollment
      enrollment = Enrollment.new(name)
    end

  end
