require 'csv'

# Represents an urban rail network: lines, stations.
# Supports finding route between two stations.
# Hold these values:
# - lines:    Hash of lines in this urban rail network. Key: line code.
#             See line.rb.
# - stations: Hash of stations in this urban rail network. Key: station name.
#             See station.rb.
#
# Data about one rail line is not needed for this kind of problem.
# We only care about adjacency of stations and their line code.
class Network
  attr_accessor :lines, :stations

  def initialize(data_file)
    @lines, @stations = DataParser.new(data_file).parse
  end

  # Returns Station object
  def find_station_by_name(station_name)
    @stations[station_name]
  end

  # Returns Station object
  def find_station_by_line_and_number(line, number)
    @lines[line]&.find_station_by_number(number)
  end
end
