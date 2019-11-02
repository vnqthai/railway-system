class DataParser
  HEADER_CODE = 'Station Code'
  HEADER_NAME = 'Station Name'
  HEADER_DATE = 'Opening Date'

  def initialize(data_file)
    @data_file = data_file
    @lines = {}
    @stations = {}
  end

  def parse
    CSV.foreach(@data_file, headers: true) do |row|
      process_row row
    end

    check_missing_station_numbers

    return @lines, @stations
  end

  private

  def process_row(row)
    code = row[HEADER_CODE].strip
    name = row[HEADER_NAME].strip
    date = row[HEADER_DATE].strip
    return unless valid_code?(code) && valid_name?(name) && valid_date?(date)

    line_code, line_number = get_line_info(code)
    open_at = Time.parse(date)

    line = @lines[line_code] ||= Line.new(line_code)
    station = @stations[name] ||= Station.new(name)
    line_station = LineStation.new(line, station, line_number, open_at)
    line.stations[line_number] = line_station
    station.set_line(line_station)
  end

  def check_missing_station_numbers
    @lines.values.each do |line|
      station_numbers = line.stations.keys.sort
      station_numbers.each_with_index do |number, index|
        # Skip first station in each line
        next if index == 0

        # Detect missing station numbers (example: NS5 -> NS7)
        prev_number = station_numbers[index - 1]
        if number - prev_number != 1
          station = line.stations[number].station
          prev_station = line.stations[prev_number].station

          # Connect `station` and `prev_station`
          station.add_adjacent_station(prev_station, line, prev_number)
          prev_station.add_adjacent_station(station, line, number)
        end
      end
    end
  end

  def get_line_info(code)
    match = code.match(/^([A-Z]{2,3})(\d{1,4})$/)
    return match[1], match[2].to_i
  end

  # Line code: 2-3 capital alphabet characters
  # Station number: 1-4 digit number
  def valid_code?(code)
    unless code =~ /^[A-Z]{2,3}\d{1,4}$/
      puts "Invalid station code: \"#{code}\". Skipping this data row."
      return false
    end

    true
  end

  # Name cannot be empty
  def valid_name?(name)
    if name.to_s.strip.length == 0
      puts "Invalid station name: \"#{name}\". Skipping this data row."
      return false
    end

    true
  end

  # If missing day ("December 2019"),
  # Opening date will be the first day of that month: "1 December 2019"
  def valid_date?(date)
    begin
      Time.parse(date)
    rescue ArgumentError, TypeError
      puts "Invalid station opening date: \"#{date}\". Skipping this data row."
      return false
    end

    true
  end

end
