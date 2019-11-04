require 'spec_helper'

describe TimeCalculator do
  let(:time) { Time.new(2001, 1, 1, 10, 0, 0) }
  let(:travel_time_ns) { 600 }
  let(:travel_time_ew) { 900 }
  let(:transfer_time) { 720 }

  before(:all) do
    @stations = []

    line_ns = Line.new('NS')
    line_ew = Line.new('EW')
    open_time = Time.new(2000, 1, 1)

    station = Station.new('Station 1'); station.set_line(LineStation.new(line_ns, station, 1, open_time)); @stations << station

    station = Station.new('Station 2'); station.set_line(LineStation.new(line_ns, station, 2, open_time)); @stations << station

    station = Station.new('Station 3'); station.set_line(LineStation.new(line_ns, station, 3, open_time))
    station.set_line(LineStation.new(line_ew, station, 10, open_time))
    @stations << station

    station = Station.new('Station 4'); station.set_line(LineStation.new(line_ew, station, 11, open_time)); @stations << station
  end

  before(:each) do
    allow(TimeService).to receive(:time_travel).with('NS', an_instance_of(Time)).and_return(travel_time_ns)
    allow(TimeService).to receive(:time_travel).with('EW', an_instance_of(Time)).and_return(travel_time_ew)
    allow(TimeService).to receive(:time_transfer).and_return(transfer_time)
  end

  describe '#time_at_step' do
    context 'stations list is empty' do
      it 'returns 0' do
        expect(TimeCalculator.new([]).time_at_step(0, time)).to eq(0)
      end
    end

    context 'step is the first step' do
      it 'returns 0' do
        expect(TimeCalculator.new(@stations).time_at_step(0, time)).to eq(0)
      end
    end

    context 'stations list is not empty and step is not the first' do
      context 'step is in the mid' do
        it 'returns travel time' do
          expect(TimeCalculator.new(@stations).time_at_step(1, time)).to eq(travel_time_ns)
        end
      end

      context 'step is the last step' do
        it 'returns travel time' do
          expect(TimeCalculator.new(@stations).time_at_step(@stations.size - 1, time)).to eq(travel_time_ew)
        end
      end
    end
  end

  describe '#transfer_at_step' do
    context 'stations list is empty' do
      it 'returns 0' do
        expect(TimeCalculator.new([]).transfer_at_step(0, time)).to eq(0)
      end
    end

    context 'step is the first step' do
      it 'returns 0' do
        expect(TimeCalculator.new(@stations).transfer_at_step(0, time)).to eq(0)
      end
    end

    context 'step is the last step' do
      it 'returns 0' do
        expect(TimeCalculator.new(@stations).transfer_at_step(@stations.size - 1, time)).to eq(0)
      end
    end

    context 'transfer is possible' do
      context 'not need to transfer' do
        it 'returns 0' do
          expect(TimeCalculator.new(@stations).transfer_at_step(1, time)).to eq(0)
        end
      end

      context 'transfer is required' do
        it 'returns transfer time' do
          expect(TimeCalculator.new(@stations).transfer_at_step(2, time)).to eq(transfer_time)
        end
      end
    end
  end

  describe '#time_all' do
    context 'stations list is empty' do
      it 'returns 0' do
        expect(TimeCalculator.new([]).time_all(time)).to eq(0)
      end
    end

    context 'stations list has only one station' do
      it 'returns 0' do
        expect(TimeCalculator.new(@stations[0..0]).time_all(time)).to eq(0)
      end
    end

    context 'stations list has no transfers' do
      it 'returns sum of time in each step' do
        expect(TimeCalculator.new(@stations[0..2]).time_all(time)).to eq(travel_time_ns * 2)
      end
    end

    context 'stations list has transfer' do
      it 'returns sum of time in each step and transfer time' do
        expected = travel_time_ns * 2 + travel_time_ew + transfer_time
        expect(TimeCalculator.new(@stations).time_all(time)).to eq(expected)
      end
    end
  end
end
