# Calculate time to travel, and tranfer in this rail system
# Based on many conditions
class TimeCalculator
  # Initialize accepts a list of stations, and time to start calculating
  def initialize(stations, time)
    @stations = stations
    @time = time
  end

  # Addition of time travel, and transfer (if any) for the last step,
  # in seconds
  # - Check the last 3 stations and visit time to find transfer
  # - Check the last 2 stations and visit time to find travel time
  # - If do not have enough station , skip that condition
  def last_step_time
    if @stations.size <= 1
      0
    elsif @stations.size == 2
      1
    else # @stations.size >= 3
      1
    end
  end

  # Total number of seconds to travel this list of stations
  def all_time

  end
end
