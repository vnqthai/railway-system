# Represents a rail line
# Hold these values:
# - code: rail line code ('NS')
# - stations: Hash of stations in this urban rail network. Key: station number.
#             Values are LineStation objects. See line_station.rb.
#
class Line
  attr_accessor :code, :stations

  def initialize(code)
    @code = code
    @stations = {}
  end

  # Returns LineStation object
  def find_station_by_number(number)
    @stations[number]&.station
  end
end
