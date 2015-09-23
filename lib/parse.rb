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
    final_rows = rows.map {|array| array.to_h}
    final_rows.select{|row| row.fetch(:location) == @district_name}
  end

end

# filename = "Students qualifying for free or reduced price lunch.csv"
# parsed_file = Parse.new("ACADEMY 20", filename).parse_runner
# data = {}
# parsed_file.each do |row|
#   if row.fetch(:poverty_level) == "Eligible for Free or Reduced Lunch"
#     data[row.fetch(:timeframe)] = row[:data]
#   end
# end
#   puts data
