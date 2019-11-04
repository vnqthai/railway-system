require 'spec_helper'

describe DataParser do
  describe '#parse' do
    before(:all) do
      @lines, @stations = DataParser.new(TEST_DATA_FULL).parse
    end

    it 'parses lines' do
      expect(@lines.size).to eq(8)
      expect(@lines.keys).to contain_exactly('NS', 'EW', 'CG', 'NE', 'CC', 'CE', 'DT', 'TE')
    end

    it 'parses stations' do
      expect(@stations.size).to eq(136)
      expect(@stations.keys).to contain_exactly('Jurong East', 'Bukit Batok', 'Bukit Gombak', 'Choa Chu Kang', 'Yew Tee', 'Kranji', 'Marsiling', 'Woodlands', 'Admiralty', 'Sembawang', 'Canberra', 'Yishun', 'Khatib', 'Yio Chu Kang', 'Ang Mo Kio', 'Bishan', 'Braddell', 'Toa Payoh', 'Novena', 'Newton', 'Orchard', 'Somerset', 'Dhoby Ghaut', 'City Hall', 'Raffles Place', 'Marina Bay', 'Marina South Pier', 'Pasir Ris', 'Tampines', 'Simei', 'Bedok', 'Kembangan', 'Eunos', 'Paya Lebar', 'Aljunied', 'Kallang', 'Lavender', 'Bugis', 'Tanjong Pagar', 'Outram Park', 'Tiong Bahru', 'Redhill', 'Queenstown', 'Commonwealth', 'Buona Vista', 'Dover', 'Clementi', 'Chinese Garden', 'Lakeside', 'Boon Lay', 'Pioneer', 'Joo Koon', 'Gul Circle', 'Tuas Crescent', 'Tuas West Road', 'Tuas Link', 'Tanah Merah', 'Expo', 'Changi Airport', 'HarbourFront', 'Chinatown', 'Clarke Quay', 'Little India', 'Farrer Park', 'Boon Keng', 'Potong Pasir', 'Woodleigh', 'Serangoon', 'Kovan', 'Hougang', 'Buangkok', 'Sengkang', 'Punggol', 'Bras Basah', 'Esplanade', 'Promenade', 'Nicoll Highway', 'Stadium', 'Mountbatten', 'Dakota', 'MacPherson', 'Tai Seng', 'Bartley', 'Lorong Chuan', 'Marymount', 'Caldecott', 'Botanic Gardens', 'Farrer Road', 'Holland Village', 'one-north', 'Kent Ridge', 'Haw Par Villa', 'Pasir Panjang', 'Labrador Park', 'Telok Blangah', 'Bayfront', 'Bukit Panjang', 'Cashew', 'Hillview', 'Beauty World', 'King Albert Park', 'Sixth Avenue', 'Tan Kah Kee', 'Stevens', 'Rochor', 'Downtown', 'Telok Ayer', 'Fort Canning', 'Bencoolen', 'Jalan Besar', 'Bendemeer', 'Geylang Bahru', 'Mattar', 'Ubi', 'Kaki Bukit', 'Bedok North', 'Bedok Reservoir', 'Tampines West', 'Tampines East', 'Upper Changi', 'Woodlands North', 'Woodlands South', 'Springleaf', 'Lentor', 'Mayflower', 'Bright Hill', 'Upper Thomson', 'Mount Pleasant', 'Napier', 'Orchard Boulevard', 'Great World', 'Havelock', 'Maxwell', 'Shenton Way', 'Marina South', 'Gardens by the Bay')
    end

    it 'sets stations to lines' do
      ns_stations = @lines['NS'].stations
      expect(ns_stations.size).to eq(27)
      expect(ns_stations.values.map { |ls| ls.station.name }).to contain_exactly('Jurong East', 'Bukit Batok', 'Bukit Gombak', 'Choa Chu Kang', 'Yew Tee', 'Kranji', 'Marsiling', 'Woodlands', 'Admiralty', 'Sembawang', 'Canberra', 'Yishun', 'Khatib', 'Yio Chu Kang', 'Ang Mo Kio', 'Bishan', 'Braddell', 'Toa Payoh', 'Novena', 'Newton', 'Orchard', 'Somerset', 'Dhoby Ghaut', 'City Hall', 'Raffles Place', 'Marina Bay', 'Marina South Pier')

      dt_stations = @lines['DT'].stations
      expect(dt_stations.size).to eq(34)
      expect(dt_stations.values.map { |ls| ls.station.name }).to contain_exactly('Bukit Panjang', 'Cashew', 'Hillview', 'Beauty World', 'King Albert Park', 'Sixth Avenue', 'Tan Kah Kee', 'Botanic Gardens', 'Stevens', 'Newton', 'Little India', 'Rochor', 'Bugis', 'Promenade', 'Bayfront', 'Downtown', 'Telok Ayer', 'Chinatown', 'Fort Canning', 'Bencoolen', 'Jalan Besar', 'Bendemeer', 'Geylang Bahru', 'Mattar', 'MacPherson', 'Ubi', 'Kaki Bukit', 'Bedok North', 'Bedok Reservoir', 'Tampines West', 'Tampines', 'Tampines East', 'Upper Changi', 'Expo')
    end

    it 'sets lines to stations' do
      station = @stations['Holland Village']
      expect(station.line_stations.size).to eq(1)
      expect(station.line_stations.keys).to contain_exactly('CC')

      station = @stations['Outram Park']
      expect(station.line_stations.size).to eq(3)
      expect(station.line_stations.keys).to contain_exactly('EW', 'NE', 'TE')
    end

    it 'sets station open time' do
      station = @stations['Dhoby Ghaut']

      open_at = station.line_stations['NS'].open_at
      expect(open_at.year).to eq(1987)
      expect(open_at.month).to eq(12)
      expect(open_at.day).to eq(12)

      open_at = station.line_stations['NE'].open_at
      expect(open_at.year).to eq(2003)
      expect(open_at.month).to eq(6)
      expect(open_at.day).to eq(20)

      open_at = station.line_stations['CC'].open_at
      expect(open_at.year).to eq(2010)
      expect(open_at.month).to eq(4)
      expect(open_at.day).to eq(17)
    end
  end
end
