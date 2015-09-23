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
    # rows.map {|row| row.to_hash}
    #h = Hash.new
    # correct_location_rows = rows.map {|row| row if row.fetch(:location) == @district_name}
    array_of_arrays = rows.to_a
    correct_arrays = array_of_arrays.map {|row| row if row[0] == @district_name}.delete_if {|e| e.nil?}
    # formatted_rows_of_hashes = correct_location_rows.map(&:to_h)


    # rows.map { |row| [row.fetch(:key), row.fetch(:value)] }.map(&:to_h)
    # hash = rows.group_by {|row| row.fetch(:location) if :location == "ACADEMY 20"}
    # hash.class
  end

end
