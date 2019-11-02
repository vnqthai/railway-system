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

  def count_transfers
    0 # TODO Complete
  end

  def output_general
    time_format = '%Y %B %d, %I:%M:%S%p'
    time_all = @time_calculator.time_all(@start_time)
    puts "Time travel: #{time_all / 60} minutes"
    puts "Start: #{@start_time.strftime(time_format)}"
    puts "Arrive: #{(@start_time + time_all).strftime(time_format)}"
    puts "Stations: #{count_stations}"
    puts "Transfers: #{count_transfers}"
  end

  def output_table
    longest_code_length = @stations.map { |s| s.line_numbers.length }.max
    longest_name_length = @stations.map { |s| s.name.length }.max
    format = "%8s  %-#{longest_code_length}s  %-#{longest_name_length}s  %10s %4s %8s\n"

    printf(format, 'Stations', 'Code', 'Name', 'Arrive', 'Time', 'Transfer')
    current_time = @start_time
    @stations.each_with_index do |station, idx|
      step_time = @time_calculator.time_at_step(idx, current_time)
      transfer_time = @time_calculator.transfer_at_step(idx, current_time)
      current_time += step_time + transfer_time
      printf(
        format,
        idx == 0 ? 'Source' : idx,
        station.line_numbers,
        station.name,
        current_time.strftime('%I:%M:%S%p'),
        step_time == 0 ? '' : step_time/60,
        transfer_time == 0 ? '' : transfer_time/60,
      )
    end
  end
end
