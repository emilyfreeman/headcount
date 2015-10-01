require_relative 'district'
require 'pry'

class DistrictRepository

  attr_accessor :repository

  def self.from_csv(path)
    filename = "Students qualifying for free or reduced price lunch.csv"
    fullpath = File.join(path, filename)
    @repository = {}
    rows = CSV.read(fullpath, headers: true, header_converters: :symbol).each do |row|
      if !@repository.include?(row[:location])
        @repository[row[:location].upcase] = District.new(row[:location].upcase)
      end
    end
    self
  end

  def self.find_by_name(name)
    if @repository.keys.include? name.upcase
      return @repository[name.upcase]
    else
      nil
    end
  end

  def self.find_all_matching(text)
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
