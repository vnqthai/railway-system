require 'pry'
Dir['./lib/**/*.rb'].each{ |f| require f }

class Railway
  DEFAULT_DATA_FILE = 'data/StationMap.csv'

  def initialize(options)
    @errors = {}
    return unless parse_and_validate_options(options)
    @network = Network.new(@data_file)
    validate_stations
  end

  def call
    return unless @errors.values.all?(&:empty?)

    routes_finder = RoutesFinder.new(@network, @start_time)

    # Can call this statement many times with different source and destination station names
    # parse input data only once
    @routes = routes_finder.find(@source, @destination)

    output

    # TODO:
    # - Read from input file a list of [source, destination], process and output. Only read data file once.
    # - Remove all `pry` things (used for debugging)
    # - Update README
    #   + Add output of routes (many cases)
    #   + Add output of commands
    # Optional:
    # - More detail spec of DataParser
  end

  private

  # Validate command options
  # This is performed BEFORE reading and parsing input data
  def parse_and_validate_options(options)
    @errors[:options] = []

    @source = options[:source].to_s.strip
    @errors[:options] << 'Source station is required.' if @source.length == 0

    @destination = options[:destination].to_s.strip
    @errors[:options] << 'Destination station is required.' if @destination.length == 0

    if @source.length != 0 && @source == @destination
      @errors[:options] << 'Source and destination stations must be different.'
    end

    begin
      @start_time = Time.parse(options[:start_time])
    rescue ArgumentError, TypeError
      @errors[:options] << 'Start time is missing or invalid.'
    end

    @data_file = options[:data_file] || DEFAULT_DATA_FILE
    @errors[:options] << 'Data file path is invalid or not an existing file.' unless File.file?(@data_file)

    puts @errors[:options]
    @errors[:options].empty?
  end

  # Validate source station:
  # - Exists, and
  # - Is opened at the start time.
  #   If this station belongs to many lines, it must be opened on at least one line
  # Validate destination station:
  # - Exists
  # This is performed AFTER reading and parsing input data
  def validate_stations
    @errors[:stations] = []

    source_station = @network.find_station_by_name(@source)
    @errors[:stations] << "Source station does not exist: #{@source}" unless source_station
    if source_station && !source_station.open?(@start_time)
      @errors[:stations] << "Source station is not opened at start time: #{@source}"
    end

    destination_station = @network.find_station_by_name(@destination)
    @errors[:stations] << "Destination station does not exist: #{@destination}" unless destination_station

    puts @errors[:stations]
    @errors[:stations].empty?
  end

  def output
    route = @routes[:time_travel]
    unless route
      puts "There is no available route from #{@source} to #{@destination} starting at #{@start_time.strftime('%Y %B %d, %H:%M:%S')}"
      puts "Reasons maybe:"
      puts "- Source and destination stations are not connected."
      puts "- Destination station is not opened at sufficient time?"
      return
    end

    puts "Fastest route to travel from #{@source} to #{@destination}:"
    puts
    route.output_general
    puts
    route.output_guides
    puts
    route.output_table
  end
end
