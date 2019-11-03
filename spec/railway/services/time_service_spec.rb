require 'spec_helper'

describe TimeService do
  describe '#peak_time?' do
    context 'is weekend' do
      it 'returns false' do
        time = Time.new(2019, 11, 3, 7, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(false)
      end
    end

    context 'is weekday but off-peak hours' do
      it 'returns false' do
        time = Time.new(2019, 11, 4, 13, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(false)
      end
    end

    context 'is weekday and right at 9AM' do
      it 'returns false' do
        time = Time.new(2019, 11, 4, 9, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(false)
      end
    end

    context 'is weekday and right at 9PM' do
      it 'returns false' do
        time = Time.new(2019, 11, 4, 21, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(false)
      end
    end

    context 'is weekday and peak hours in the morning' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 7, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(true)
      end
    end

    context 'is weekday and peak hours in the evening' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 20, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(true)
      end
    end

    context 'is weekday and right at 6AM' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 6, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(true)
      end
    end

    context 'is weekday and right at 6PM' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 18, 0, 0, "+08:00")
        expect(TimeService.peak_time?(time)).to eq(true)
      end
    end
  end

  describe '#peak_time?' do
    context 'in the morning' do
      it 'returns false' do
        time = Time.new(2019, 11, 4, 9, 0, 0, "+08:00")
        expect(TimeService.night_time?(time)).to eq(false)
      end
    end

    context 'at night' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 1, 0, 0, "+08:00")
        expect(TimeService.night_time?(time)).to eq(true)
      end
    end

    context 'right at 10PM' do
      it 'returns true' do
        time = Time.new(2019, 11, 4, 22, 0, 0, "+08:00")
        expect(TimeService.night_time?(time)).to eq(true)
      end
    end

    context 'right at 6AM' do
      it 'returns false' do
        time = Time.new(2019, 11, 4, 6, 0, 0, "+08:00")
        expect(TimeService.night_time?(time)).to eq(false)
      end
    end
  end

  # Other methods:
  # - time_transfer
  # - time_travel
  # - time_travel_*
  # Are straightforward and depend on tested methods,
  # So do not need to add spec for them at the moment.
end
