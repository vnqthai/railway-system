require 'railway'

describe LineStation do
  let(:open_time) { Time.new(2000, 1, 1) }
  let(:station) { Station.new('Station') }
  let(:line) { Line.new('NS') }
  let(:line_station) { LineStation.new(line, station, 10, open_time) }

  describe '#code' do
    it 'returns line code and number' do
      expect(line_station.code).to eq('NS10')
    end
  end

  describe '#open?' do
    context 'station is still in development and not opened' do
      it 'returns false' do
        expect(line_station.open?(Time.new(1999, 1, 1))).to eq(false)
      end
    end

    context 'line closed at night time' do
      it 'returns false' do
        expect(line).to receive(:close_at_night_time?).and_return(true)
        expect(TimeService).to receive(:night_time?).and_return(true)
        expect(line_station.open?(Time.new(2001, 1, 1))).to eq(false)
      end
    end

    context 'it is in operation and not closed at night time' do
      it 'returns true' do
        expect(line).to receive(:close_at_night_time?).and_return(false)
        expect(line_station.open?(Time.new(2001, 1, 1))).to eq(true)
      end
    end
  end
end
