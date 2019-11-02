# A route from one source to another destination station
# Store an array of Station objects. See station.rb
class Route
  attr_accessor :stations, :start_time, :time_travelled

  def initialize(stations, start_time, time_travelled)
    @stations = stations
    @start_time = start_time
    @time_travelled = time_travelled
  end

  def station_count
    @stations.size
  end
end
