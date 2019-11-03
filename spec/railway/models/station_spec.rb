require 'spec_helper'

describe Station do
  let(:name) { 'Station S' }
  let(:station) { Station.new(name) }
  let(:open_time) { Time.new(2000, 1, 1) }

  let(:line_ns) { Line.new('NS') }
  let(:line_station_ns) { LineStation.new(line_ns, station, 1, open_time) }

  let(:line_ew) { Line.new('EW') }
  let(:line_station_ew) { LineStation.new(line_ew, station, 32, open_time) }

  before do
    line_ns.stations[1] = line_station_ns
    line_ew.stations[32] = line_station_ew
  end

  shared_context 'set lines' do
    before do
      station.set_line(line_station_ns)
      station.set_line(line_station_ew)
    end
  end

  describe '#line_numbers' do
    include_context 'set lines'

    it 'returns line numbers of this station' do
      line_numbers = station.line_numbers
      expect(line_numbers).to include('NS1')
      expect(line_numbers).to include('EW32')
    end
  end

  describe '#line_numbers_and_name' do
    include_context 'set lines'

    it 'returns line numbers and name of this station' do
      line_numbers_and_name = station.line_numbers_and_name
      expect(line_numbers_and_name).to include('NS1')
      expect(line_numbers_and_name).to include('EW32')
      expect(line_numbers_and_name).to include(name)
    end
  end

  describe '#line_codes' do
    include_context 'set lines'

    it 'returns line numbers and name of this station' do
      line_codes = station.line_codes
      expect(line_codes.size).to eq(2)
      expect(line_codes).to include('NS')
      expect(line_codes).to include('EW')
    end
  end

  describe '#set_line' do
    it 'sets this station into its line' do
      station.set_line(line_station_ew)
      expect(station.line_stations['EW']).to eq(line_station_ew)
    end

    it 'sets adjacent stations with next-to indices (-1, 1)' do
      station_ns2 = Station.new('Station NS2')
      station_ew31 = Station.new('Station EW31')
      station_ew33 = Station.new('Station EW33')

      line_ns.stations[2] = LineStation.new(line_ns, station_ns2, 2, open_time)
      line_ew.stations[31] = LineStation.new(line_ew, station_ew31, 31, open_time)
      line_ew.stations[33] = LineStation.new(line_ew, station_ew33, 33, open_time)

      station.set_line(line_station_ew)
      station.set_line(line_station_ns)

      adjacent_stations = station.adjacent_stations
      expect(adjacent_stations.size).to eq(3)
      expect(adjacent_stations).to include(station_ns2)
      expect(adjacent_stations).to include(station_ew31)
      expect(adjacent_stations).to include(station_ew33)
    end
  end

  describe '#add_adjacent_station' do
    context 'adjacent station does not exist' do
      it 'do nothing' do
        station.add_adjacent_station(nil, line_ns, 10)
        expect(station.adjacent_stations).to be_empty
      end
    end

    context 'adjacent station exists' do
      it 'sets adjacent stations' do
        station_next = Station.new('Station Next')
        station.add_adjacent_station(station_next, line_ns, 10)
        expect(station.adjacent_stations).to include(station_next)
      end
    end
  end

  describe '#adjacent_stations' do
    context 'there is no adjacent station' do
      it 'returns empty array' do
        expect(station.adjacent_stations).to be_empty
      end
    end

    context 'there are some adjacent stations' do
      it 'returns adjacent stations' do
        station_next1 = Station.new('Station Next 1')
        station_next2 = Station.new('Station Next 2')

        station.add_adjacent_station(station_next1, line_ew, 11)
        station.add_adjacent_station(station_next2, line_ew, 12)

        expect(station.adjacent_stations.size).to eq(2)
        expect(station.adjacent_stations).to include(station_next1)
        expect(station.adjacent_stations).to include(station_next2)
      end
    end
  end

  describe '#open?' do
    include_context 'set lines'

    context 'any line' do
      context 'one line (of two) opens' do
        it 'returns true' do
          allow(line_station_ns).to receive(:open?).and_return(true)
          allow(line_station_ew).to receive(:open?).and_return(false)
          expect(station.open?(open_time)).to eq(true)
        end
      end

      context 'all lines closed' do
        it 'returns false' do
          expect(line_station_ns).to receive(:open?).and_return(false)
          expect(line_station_ew).to receive(:open?).and_return(false)
          expect(station.open?(open_time)).to eq(false)
        end
      end
    end

    context 'line is specified' do
      it "return line's open status" do
        expect(line_station_ns).to receive(:open?).and_return(true)
        expect(station.open?(open_time, 'NS')).to eq(true)
      end
    end
  end

  describe '#common_line_codes' do
    include_context 'set lines'

    context 'no common line' do
      it 'returns empty' do
        other_station = Station.new('Station T')
        other_station.set_line(LineStation.new(Line.new('CG'), other_station, 10, open_time))
        expect(station.common_line_codes(other_station)).to be_empty
      end
    end

    context 'one common line' do
      it 'returns the only common line code' do
        other_station = Station.new('Station T')
        other_station.set_line(LineStation.new(Line.new('NS'), other_station, 10, open_time))
        commons = station.common_line_codes(other_station)
        expect(commons).to contain_exactly('NS')
      end
    end

    context 'many common lines' do
      it 'returns all these common line codes' do
        other_station = Station.new('Station T')
        other_station.set_line(LineStation.new(Line.new('NS'), other_station, 10, open_time))
        other_station.set_line(LineStation.new(Line.new('EW'), other_station, 20, open_time))
        commons = station.common_line_codes(other_station)
        expect(commons).to contain_exactly('NS', 'EW')
      end
    end
  end
end
