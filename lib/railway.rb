require 'pry'
Dir['./**/*.rb'].each{ |f| require f }

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

    #TODO:
    # - Case: no route found
    #   Source station opened at start time, but destination station not opened at arrive time
    # - Read from input file a list of [source, destination], process and output. Only read data file once.
    # - Test same source and destination station
    # - Remove all `pry` things (used for debugging)
  end

  private

  # Validate command options
  # This is performed BEFORE reading and parsing input data
  def parse_and_validate_options(options)
    @errors[:options] = []

    @source = options[:source]
    @errors[:options] << 'Source station is required.' if @source.to_s.strip.length == 0

    @destination = options[:destination]
    @errors[:options] << 'Destination station is required.' if @destination.to_s.strip.length == 0

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
    puts "Fasted route to travel from #{@source} to #{@destination}:"
    puts
    @routes[:time_travel].output_general
    puts
    puts 'Friendly view:'
    puts
    puts 'Table view:'
    @routes[:time_travel].output_table
    puts
    puts 'Notes: times are in minutes'
  end
end
