require_relative 'district'
require 'pry'

class DistrictRepository

  attr_accessor :repository

  def initialize
  end

  def self.from_csv(path)
    # opens one csv in folder
    filename = "Students qualifying for free or reduced price lunch.csv"
    fullpath = File.join(path, filename)
    @repository = {}
    # pushes it into parser
    rows = CSV.read(fullpath, headers: true, header_converters: :symbol).each do |row|
      # only push unique names into our hash and have them point to its instance of District
      if !@repository.include?(row[:location])
        @repository[row[:location].upcase] = District.new(row[:location].upcase)
      end
    end
    # returns hash containing just district names as strings
    # binding.pry
    self
  end

  def self.find_by_name(name)
    # searches returned hash above for district name; receives string; - returns instance of district
    if @repository.keys.include? name.upcase
      return @repository[name.upcase]
    else
      nil
    end
  end

  def self.find_all_matching(text)
    # find_all_matching - returns either [] or one or more matches which contain the supplied name fragment, case insensitive
    @repository.select{|k, v|
      if k.include?(text.upcase)
        v
      end
    }.values.to_a
  end

  def self.repository_holder
    @repository


  end

  def self.path
    set_path('../data')
    File.expand_path(@path, __dir__)
  end

  def self.set_path(path)
    @path = path
  end
end
