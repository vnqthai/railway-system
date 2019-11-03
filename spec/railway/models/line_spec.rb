require 'spec_helper'

describe Line do
  describe '#find_station_by_number' do
    let(:station) { Station.new('Station 1') }
    let(:line) { Line.new('NS') }
    let(:line_number) { 1 }
    let(:line_station) { LineStation.new(line, station, line_number, Time.new(2000, 1, 1)) }

    before { line.stations[line_number] = line_station }

    context 'station number exists' do
      it 'returns station at specific number' do
        expect(line.find_station_by_number(line_number)).to eq(station)
      end
    end

    context 'station snumber NOT exists' do
      it 'returns nil' do
        expect(line.find_station_by_number(2)).to be_nil
      end
    end
  end

  describe '#close_at_night_time?' do
    context 'line closes at night time' do
      let(:line) { Line.new('DT') }

      it 'returns true' do
        expect(line.close_at_night_time?).to eq(true)
      end
    end

    context 'line operates at night time' do
      let(:line) { Line.new('NS') }

      it 'returns true' do
        expect(line.close_at_night_time?).to eq(false)
      end
    end
  end
end
