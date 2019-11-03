# A connection between Line and Station
# Store information represents this Line-Station connection:
# - line: Line object. See line.rb.
# - station: Station object. See station.rb.
# - number: station number (1, 2, 32, etc.)
# - open_at: date of opening, can be in the past or in the future
class LineStation
  attr_accessor :line, :station, :number, :open_at

  def initialize(line, station, number, open_at)
    @line = line
    @station = station
    @number = number
    @open_at = open_at
  end

  def code
    "#{@line.code}#{number}"
  end

  def open?(time)
    time >= @open_at &&
      !(@line.close_at_night_time? && TimeService.night_time?(time))
  end
end
