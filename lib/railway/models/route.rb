# A route from one source to another destination station
# Store an array of Station objects. See station.rb
class Route
  attr_accessor :stations, :start_time

  def initialize(stations, start_time)
    @stations = stations
    @start_time = start_time
    @time_calculator = TimeCalculator.new(@stations)
  end

  def count_stations
    @stations.size - 1
  end

  def output_general
    format = "%-12s %-100s\n"
    time_format = '%Y %B %d, %I:%M:%S%p'
    time_all = @time_calculator.time_all(@start_time)
    time_all_in_minute = time_all / 60
    time_all_in_hour = time_all_in_minute / 60
    minute_text = "minute#{plural_text(time_all_in_minute)}"
    hour_text = "hour#{plural_text(time_all_in_hour)}"

    printf(format, 'Time travel:', "#{time_all_in_hour} #{hour_text} #{time_all_in_minute % 60} #{minute_text}")
    printf(format, 'Start:', @start_time.strftime(time_format))
    printf(format, 'Arrive:', (@start_time + time_all).strftime(time_format))
    printf(format, 'Stations:', count_stations)
    printf(format, 'Transfers:', count_transfers)
  end

  def output_guides
    prev_idx = 0

    transfers.each do |transfer_idx|
      station_from = @stations[prev_idx]
      station_transfer = @stations[transfer_idx]
      line_from = station_from.common_line_codes(station_transfer).join('/')
      line_to = station_transfer.common_line_codes(@stations[transfer_idx + 1]).join('/')

      stops_count = transfer_idx - prev_idx
      stops_text = "stop#{plural_text(stops_count)}"
      puts "On line #{line_from}, travel from #{station_from.name} to #{station_transfer.name}, #{stops_count} #{stops_text}"
      puts "Transfer from line #{line_from} to line #{line_to} at #{@stations[transfer_idx].name}"
      prev_idx = transfer_idx
    end

    station_from = @stations[prev_idx]
    station_last = @stations.last
    line_from = station_from.common_line_codes(station_last).join('/')
    stops_count = @stations.size - 1 - prev_idx
    stops_text = "stop#{plural_text(stops_count)}"
    puts "On line #{line_from}, travel from #{station_from.name} to #{station_last.name}, #{stops_count} #{stops_text}"
  end

  def output_table
    longest_name_length = @stations.map { |s| s.name.length }.max
    format = "%10s  %-#{longest_name_length}s  %10s %4s %8s\n"

    printf(format, 'Stations', 'Name', 'Arrive', 'Time', 'Transfer')
    current_time = @start_time
    @stations.each_with_index do |station, idx|
      step_time = @time_calculator.time_at_step(idx, current_time)
      transfer_time = @time_calculator.transfer_at_step(idx, current_time)
      current_time += step_time
      printf(
        format,
        idx == 0 ? 'Source = 0' : idx,
        station.name,
        current_time.strftime('%I:%M:%S%p'),
        step_time == 0 ? '' : step_time/60,
        transfer_time == 0 ? '' : transfer_time/60,
      )
      current_time += transfer_time
    end
  end

  private

  def count_transfers
    (0..(@stations.size - 1)).count { |idx| has_transfer(idx) }
  end

  def has_transfer(step)
    step > 0 &&
      step < (@stations.size - 1) &&
      @stations[step - 1].common_line_codes(@stations[step + 1]).empty?
  end

  def transfers
    (0..(@stations.size - 1)).select { |idx| has_transfer(idx) }
  end

  def plural_text(num)
    num > 1 ? 's' : ''
  end
end
