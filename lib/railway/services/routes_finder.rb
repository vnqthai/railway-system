# Find routes from any source to any destination station
# in a Network
class RoutesFinder
  def initialize(network, start_time)
    @network = network
    @start_time = start_time
    @time = start_time
  end

  # Find routes, if any, from source to destination station
  # Can call many times for different sources and destinations
  # Use Depth First Search to find possible route(s)
  # Params are station names
  # Returns an array of Routes
  def find(source, destination)
    @source_station = @network.find_station_by_name(source)
    @destination = destination

    prepare
    visit(@source_station)
    @routes
    binding.pry
  end

  private

  def prepare
    # Stores the result: best Route by criteria
    # Key: criteria
    # Value: best Route of this criteria
    @routes = {
      station_count: nil
    }

    # Best criteria found so far
    @bests = {
      station_count: @network.stations.size, # Total number of stations
      time_travelled: 999_999_999 # Upper bound (in seconds) to travel and transfer all stations
    }

    # Current route's value based on some criteria.
    # Used to compare with @bests
    @currents = {
      station_count: 0,
      time_travelled: 0 # in seconds
    }

    # All nodes in current checking route (may or may not heading to destination station)
    @stack = []

    # Mark if a station is visited.
    # Key: station name.
    # Value: boolean
    @marks = {}
  end

  def visit(station)
    @stack << station
    @marks[station.name] = true
    @currents[:station_count] += 1
    added_time = TimeCalculator.new(@stack, @time).last_step_time
    @time += added_time
    @currents[:time_travelled] += added_time

    station_count = @currents[:station_count]
    time_travelled = @currents[:time_travelled]
    # Not better than current best in any criteria
    unless time_travelled < @bests[:time_travelled] ||
        station_count < @bests[:station_count]
      backtrack(station, added_time)
      return
    end

    # Reach destination
    if station.name == @destination
      if time_travelled < @bests[:time_travelled] # Found a better time travelled
        @bests[:time_travelled] = time_travelled
        @routes[:time_travelled] = new_route
      elsif station_count < @bests[:station_count] # Found a better station count
        @bests[:station_count] = station_count
        @routes[:station_count] = new_route
      end

    # Continue with next station(s)
    else
      station.adjacent_stations.each do |adjacent_station|
        if !@marks[adjacent_station.name] && opened?(station, adjacent_station)
          visit(adjacent_station)
        end
      end
    end
    # TODO:
    # - Check other criteria: number of transfers

    backtrack(station, added_time)
  end

  def backtrack(station, added_time)
    @currents[:time_travelled] -= added_time
    @time -= added_time
    @currents[:station_count] -= 1
    @marks[station.name] = false
    @stack.pop
  end

  # Check if BOTH from- and to- stations are opened at the arrive time
  # Check BOTH because need to handle transfers in case of multi-line stations,
  # Station X on line A is opened but maybe station X on line B is not opened.
  def opened?(station_from, station_to)
    station_from.common_line_codes(station_to).any? do |line_code|
      station_from.opened?(@time, line_code) &&
        station_to.opened?(@time, line_code)
    end
  end

  def new_route
    Route.new(@stack.clone, @start_time, @currents[:time_travelled])
  end
end
