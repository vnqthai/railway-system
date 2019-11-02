# Represents a rail station. Station may appear in many lines.
# Hold these values:
# - name: station name ('Buona Vista')
# - line_stations: Hash of lines this station belongs to. Key: line code
#                  Values are LineStation objects. See line_station.rb.
# - adjacents: Hash of adjacent stations.
#              Keys: Line code, then station number in that line. Example: { 'DT': { 21: <Station object> } }
#              Values are Station objects
class Station
  attr_accessor :name, :line_stations

  def initialize(name)
    @name = name
    @line_stations = {}
    @adjacents = {}
  end

  def line_numbers
    results = []
    @line_stations.values.each do |ls|
      results << ls.code
    end
    results.join '/'
  end

  def line_numbers_and_name
    "#{line_numbers} #{name}"
  end

  def line_codes
    line_stations.keys
  end

  # Add this station into its line
  # Set its adjacent stations in this line
  def set_line(line_station)
    @line_stations[line_station.line.code] = line_station

    add_adjacent_by_diff(line_station, -1)
    add_adjacent_by_diff(line_station, 1)
  end

  def add_adjacent_station(station, line, number)
    return unless station

    if @adjacents[line.code]
      @adjacents[line.code][number] = station
    else
      @adjacents[line.code] = { number => station }
    end
  end

  def adjacent_stations
    result = []
    @adjacents.values.each do |line|
      line.values.each do |station|
        result << station
      end
    end
    result
  end

  def open?(time, line_code = nil)
    if line_code
      line_stations[line_code].open?(time)
    else
      line_stations.values.any? { |ls| ls.open?(time) }
    end
  end

  # Return array of line codes that this station and other_station both belong to
  # Can be empty, one element, or many elements
  # Two stations can both belong to many lines
  # Eexample: City Hall & Raffles Place both belong to EW & NS lines
  def common_line_codes(other_station)
    line_codes & other_station.line_codes
  end

  private

  def add_adjacent_by_diff(line_station, number_diff)
    adjacent_number = line_station.number + number_diff
    line = line_station.line
    adjacent_station = line.stations[adjacent_number]&.station

    # Not add adjacent if invalid or non-exist station
    # (number = 0, number too big)
    return unless adjacent_station

    add_adjacent_station(adjacent_station, line, adjacent_number)

    # Add this station as adjacent of adjacent_station
    # Trains can run in both directions on every line
    adjacent_station.add_adjacent_station(self, line, line_station.number)
  end
end
