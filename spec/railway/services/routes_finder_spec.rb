require 'spec_helper'

describe RoutesFinder do
  before(:all) do
    @network_full = Network.new(TEST_DATA_FULL)
    @network_part = Network.new(TEST_DATA_PART)
  end

  describe '#find' do
    context 'there are stations in network that is not connected to others' do
      let(:routes_finder) { RoutesFinder.new(@network_part, Time.new(2100, 1, 1, 10, 0, 0)) }

      it 'found no routes between not-connected stations' do
        routes = routes_finder.find('Jurong East', 'Tanjong Rhu')
        expect(routes).to be_empty
      end

      it 'can find routes between connected stations in the same line' do
        routes = routes_finder.find('Admiralty', 'City Hall')
        expect(routes).to_not be_empty

        fastest_route = routes[:time_travel]
        expect(fastest_route.count_stations).to eq(15)
        expect(fastest_route.count_transfers).to eq(0)
      end

      it 'can find routes between connected stations in different lines' do
        routes = routes_finder.find('Admiralty', 'Buona Vista')
        expect(routes).to_not be_empty

        fastest_route = routes[:time_travel]
        expect(fastest_route.count_stations).to eq(11)
        expect(fastest_route.count_transfers).to eq(1)
        expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Jurong East')
      end
    end

    context 'all stations in network is connected' do
      let(:start_time) { Time.new(2100, 1, 1, 10, 0, 0) }
      let(:routes_finder) { RoutesFinder.new(@network_full, start_time) }

      context 'source and destination stations are identical' do
        it 'returns a route with just only source station and no step' do
          routes = routes_finder.find('Raffles Place', 'Raffles Place')

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(0)
          expect(fastest_route.count_transfers).to eq(0)
        end
      end

      context 'source and destination stations are next to each other' do
        it 'returns route with only one step' do
          routes = routes_finder.find('Khatib', 'Yio Chu Kang')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(1)
          expect(fastest_route.count_transfers).to eq(0)
        end
      end

      context 'need more than 1 step, but travel in the same line' do
        it 'returns route with many steps and no tranfser' do
          routes = routes_finder.find('Punggol', 'Chinatown')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(13)
          expect(fastest_route.count_transfers).to eq(0)
        end
      end

      context 'need to change line once' do
        it 'returns route with many steps and 1 tranfser' do
          routes = routes_finder.find('Punggol', 'Bugis')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(12)
          expect(fastest_route.count_transfers).to eq(1)
          expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Little India')
        end
      end

      context 'need to change line many times' do
        it 'returns route with many steps and many tranfsers' do
          routes = routes_finder.find('Punggol', 'Tampines West')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(13)
          expect(fastest_route.count_transfers).to eq(2)
          expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Serangoon', 'MacPherson')
        end
      end

      context 'fastest route contains closed-at-night line' do
        # After 10PM, DT line does not operate
        let(:start_time) { Time.new(2100, 1, 1, 23, 0, 0) }

        it 'chooses the next fastest route which does not use the closed line to transfer' do
          routes = routes_finder.find('Punggol', 'Bugis')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(13)
          expect(fastest_route.count_transfers).to eq(2)
          expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Dhoby Ghaut', 'City Hall')
        end
      end

      context 'fastest route contains not-finish-construction stations' do
        # Before 2013, stations on DT line were not opened
        let(:start_time) { Time.new(2012, 1, 1, 10, 0, 0) }

        it 'chooses the next fastest route which does not use the not-finish-construction stations' do
          routes = routes_finder.find('Farrer Park', 'Novena')
          expect(routes).to_not be_empty

          fastest_route = routes[:time_travel]
          expect(fastest_route.count_stations).to eq(6)
          expect(fastest_route.count_transfers).to eq(1)
          expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Dhoby Ghaut')
        end
      end

      context 'source and destination stations are on the same line, but taking transfers is faster' do
        context 'take one transfer' do
          it 'chooses the transfer route instead' do
            routes = routes_finder.find('Jurong East', 'Marina Bay')
            expect(routes).to_not be_empty

            fastest_route = routes[:time_travel]
            expect(fastest_route.count_stations).to eq(11)
            expect(fastest_route.count_transfers).to eq(1)
            expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Outram Park')
          end
        end

        context 'take more than one transfer' do
          it 'chooses the multiple-transfer route instead' do
            routes = routes_finder.find('Bukit Panjang', 'Expo')
            expect(routes).to_not be_empty

            fastest_route = routes[:time_travel]
            expect(fastest_route.count_stations).to eq(24)
            expect(fastest_route.count_transfers).to eq(2)
            expect(fastest_route.transfer_stations.map(&:name)).to contain_exactly('Botanic Gardens', 'MacPherson')
          end
        end
      end
    end
  end
end
