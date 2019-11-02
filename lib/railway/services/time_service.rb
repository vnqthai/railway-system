class TimeService
  class << self
    # From 6am (inclusive) to 9am (exclusive)
    # and 6pm (inclusive) to 9pm (exclusive)
    # on Mon-Fri
    def peak_time?(time)
      hour = time.hour
      time.wday.between?(1, 5) && # Monday->Friday
        ((hour >= 6 && hour < 9) || (hour >= 18 && hour < 21))
    end

    # From 10pm (inclusive) to 6am (exclusive)
    # on Mon-Sun
    def night_time?(time)
      hour = time.hour
      hour >= 22 || hour < 6
    end

    def time_transfer(time)
      if peak_time?(time)
        15
      else
        10
      end*60
    end

    def time_travel(line_code, time)
      if peak_time?(time)
        time_travel_peak(line_code)
      elsif night_time?(time)
        time_travel_night(line_code)
      else
        time_travel_non_peak(line_code)
      end
    end

    def time_travel_peak(line_code)
      case line_code
      when 'NS', 'NE'
        12
      else
        10
      end*60
    end

    def time_travel_night(line_code)
      case line_code
      when 'DT', 'CG', 'CE' # Not operate at night time
        0
      when 'TE'
        8
      else
        10
      end*60
    end

    def time_travel_non_peak(line_code)
      case line_code
      when 'DT', 'TE '
        8
      else
        10
      end*60
    end
  end
end
