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
    rows.map {|row| row if row.fetch(:location) == @district_name}.map(&:to_h)
    # rows.map { |row| [row.fetch(:key), row.fetch(:value)] }.map(&:to_h)
    # hash = rows.group_by {|row| row.fetch(:location) if :location == "ACADEMY 20"}
    # hash.class
  end

end
