require 'csv'
require 'pry'

class Parse
  # takes a filename; returns parsed hash

  def initialize(district_name, filename, data_hash={})
    @district_name = district_name
    @filename = filename
    @data_hash = data_hash
  end

  def parse_runner
    rows = create_row_table
    hash = return_hash_from_row_table(rows)
  end

  def create_row_table
    path = File.expand_path("../data", __dir__)
    fullpath = File.join(path, @filename)
    CSV.read(fullpath, headers: true, header_converters: :symbol)
  end

  def return_hash_from_row_table(rows)

    array = rows.to_a

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
  end

# #notes from josh
#
# class District repository
#   def initailize(csv_loader)
#     @csvloader = csvloader
#   end
#   def find_by_name(bame)
#     District.new(name, @csvloader)
#   end
# end

# initiailize(districts_data)
# @districts_data
#   data = {
#     "ACADEMY 20" =>
#     {economic_profile =>
#       lunch_thing: 123
#     }
#   }

# @districts_by_name = districts_data.map do |name, district_data|
#   [name.upcase, District.new(name, district_Data)]}.to_h
# end
#
# class District
#
#   @econom_profile = EconomicProfile.new(data[data])
# attr_accessor :economic profile
# def initailzie(name, data)
#   @name = name
#   @data = data




end
