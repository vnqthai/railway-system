# Calculate time to travel, and tranfer in this rail system
# Based on many conditions
class TimeCalculator
  # Initialize accepts a list of stations
  def initialize(stations)
    @stations = stations
  end

  # Check the last 3 stations and visit time to find transfer
  # in seconds
  def time_at_step(step, time)
    return 0 if @stations.size <= 1 || step <= 0 # Not have enough station, skip

    @stations[step - 1].common_line_codes(@stations[step]).map do |line_code|
      TimeService.time_travel(line_code, time)
    end.min
  end

  def transfer_at_step(step, time)
    # Not have enough station, or first/last station so do not transfer
    return 0 if @stations.size <= 2 || step <= 0 || step >= (@stations.size - 1)

    if @stations[step - 1].common_line_codes(@stations[step + 1]).empty? # Different lines, need transfer
      TimeService.time_transfer(time)
    else
      0
    end
  end

  # Total number of seconds to travel this list of stations
  def time_all(start_time)
    current_time = start_time
    sum = 0
    @stations.each_with_index do |station, idx|
      step_time = time_at_step(idx, current_time)
      transfer_time = transfer_at_step(idx, current_time)
      current_time += step_time + transfer_time
      sum += step_time + transfer_time
    end
    sum
  end
end
