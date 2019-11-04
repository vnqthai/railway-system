require 'spec_helper'

describe Railway do
  subject { Railway.new(options).call }

  context 'options are invalid' do
    context 'source station is missing' do
      shared_examples 'missing source station' do
        it 'shows missing source station error' do
          expect { subject }.to output(/Source station is required./).to_stdout
        end
      end

      context 'source station is nil' do
        let(:options) { { source: nil } }
        include_examples 'missing source station'
      end

      context 'source station is empty string' do
        let(:options) { { source: '' } }
        include_examples 'missing source station'
      end

      context 'source station has only whitespaces' do
        let(:options) { { source: '  ' } }
        include_examples 'missing source station'
      end
    end

    context 'destination station is missing' do
      shared_examples 'missing destination station' do
        it 'shows missing destination station error' do
          expect { subject }.to output(/Destination station is required./).to_stdout
        end
      end

      context 'destination station is nil' do
        let(:options) { { destination: nil } }
        include_examples 'missing destination station'
      end

      context 'destination station is empty string' do
        let(:options) { { destination: '' } }
        include_examples 'missing destination station'
      end

      context 'destination station has only whitespaces' do
        let(:options) { { destination: '  ' } }
        include_examples 'missing destination station'
      end
    end

    context 'source and destination stations exists but identical' do
      shared_examples 'duplicated source and destination stations' do
        it 'shows duplicated source and destination stations error' do
          expect { subject }.to output(/Source and destination stations must be different./).to_stdout
        end
      end

      context 'identical source and destination station names' do
        let(:options) { { source: 'Station 1', destination: 'Station 1' } }
        include_examples 'duplicated source and destination stations'
      end

      context 'different source and destination station names but include spaces' do
        let(:options) { { source: 'Station 1   ', destination: '   Station 1  ' } }
        include_examples 'duplicated source and destination stations'
      end
    end

    context 'start time is invalid' do
      shared_examples 'missing or invalid start time' do
        it 'shows missing or invalid start time error' do
          expect { subject }.to output(/Start time is missing or invalid./).to_stdout
        end
      end

      context 'start time is missing' do
        context 'start time is nil' do
          let(:options) { { start_time: nil } }
          include_examples 'missing or invalid start time'
        end

        context 'start time is empty string' do
          let(:options) { { start_time: '' } }
          include_examples 'missing or invalid start time'
        end

        context 'start time is only whitespaces' do
          let(:options) { { start_time: '   ' } }
          include_examples 'missing or invalid start time'
        end
      end

      context 'start time exists but is an invalid date time string' do
        context 'start time is not a date time string' do
          let(:options) { { start_time: 'abcd' } }
          include_examples 'missing or invalid start time'
        end

        context 'start time has only year and month' do
          let(:options) { { start_time: '2019-01' } }
          include_examples 'missing or invalid start time'
        end
      end
    end

    context 'data file is not a valid and existing file' do
      let(:options) { { data_file: 'invalid_file.csv' } }

      it 'shows invalid data file error' do
        expect { subject }.to output(/Data file path is invalid or not an existing file./).to_stdout
      end
    end
  end

  context 'source station input is invalid' do
    let(:options) do
      {
        source: name,
        destination: 'Eunos',
        start_time: start_time,
        data_file: TEST_DATA_FULL
      }
    end

    context 'source station does not exist' do
      let(:name) { 'Station S' }
      let(:start_time) { '2100-01-01T10:00:00' }

      it 'shows source station does not exist error' do
        expect { subject }.to output(/Source station does not exist: #{name}/).to_stdout
      end
    end

    context 'source station exists but is not opened at start time' do
      context 'source station belongs to only one line' do
        let(:name) { 'Sixth Avenue' }
        let(:start_time) { '2015-01-12T10:00:00' }

        it 'shows source station is not opened error' do
          expect { subject }.to output(/Source station is not opened at start time: #{name}/).to_stdout
        end
      end

      context 'source station belongs to many lines' do
        let(:name) { 'Botanic Gardens' }
        let(:start_time) { '2011-01-10T10:00:00' }

        it 'shows source station is not opened error' do
          expect { subject }.to output(/Source station is not opened at start time: #{name}/).to_stdout
        end
      end
    end
  end

  context 'destination station input is invalid' do
    let(:options) do
      {
        source: 'Eunos',
        destination: name,
        start_time: '2100-01-01T10:00:00',
        data_file: TEST_DATA_FULL
      }
    end

    context 'destination station does not exist' do
      let(:name) { 'Station S' }

      it 'shows destination station does not exist error' do
        expect { subject }.to output(/Destination station does not exist: #{name}/).to_stdout
      end
    end
  end

  context 'options and input stations are valid' do
    let(:expected) { [] }
    let(:expected_regex) { /#{expected.join('[\s\S]+')}/ }

    context 'there are stations in network that is not connected to others' do
      let(:options) do
        {
          source: source,
          destination: destination,
          start_time: '2100-01-01T10:00:00',
          data_file: TEST_DATA_PART
        }
      end

      context 'source and destination stations are not connected' do
        let(:source) { 'Jurong East' }
        let(:destination) { 'Tanjong Rhu' }

        it 'shows no-route detailed message' do
          expect { subject }.to output(
            <<~NO_ROUTE
              There is no available route from #{source} to #{destination} starting at 2100 January 01, 10:00:00
              Reasons maybe:
              - Source and destination stations are not connected.
              - Destination station is not opened at sufficient time?
            NO_ROUTE
          ).to_stdout
        end
      end

      context 'source and destination stations are on the same line' do
        let(:source) { 'Admiralty' }
        let(:destination) { 'City Hall' }

        it 'shows detailed fastest route' do
          expected << 'Time travel: 2 hours 30 minutes'
          expected << "On line NS, travel from #{source} to #{destination}, 15 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'source and destination stations are on different lines' do
        let(:source) { 'Admiralty' }
        let(:destination) { 'Buona Vista' }

        it 'shows detailed fastest route with transfer' do
          expected << 'Time travel: 2 hours 0 minute'
          expected << "On line NS, travel from #{source} to Jurong East, 8 stops"
          expected << "Transfer from line NS to line EW at Jurong East"
          expected << "On line EW, travel from Jurong East to #{destination}, 3 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end
    end

    context 'all stations in network is connected' do
      let(:start_time) { '2100-01-01T10:00:00' }
      let(:options) do
        {
          source: source,
          destination: destination,
          start_time: start_time,
          data_file: TEST_DATA_FULL
        }
      end

      context 'source and destination stations are next to each other' do
        let(:source) { 'Khatib' }
        let(:destination) { 'Yio Chu Kang' }

        it 'shows detailed fastest route between 2 stations' do
          expected << 'Time travel: 0 hour 10 minutes'
          expected << "On line NS, travel from #{source} to #{destination}, 1 stop"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'need more than 1 step, but travel in the same line' do
        let(:source) { 'Punggol' }
        let(:destination) { 'Chinatown' }

        it 'shows detailed fastest route between 2 stations with no transfer' do
          expected << 'Time travel: 2 hours 10 minutes'
          expected << "On line NE, travel from #{source} to #{destination}, 13 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'need to change line once' do
        let(:source) { 'Punggol' }
        let(:destination) { 'Bugis' }

        it 'shows detailed fastest route between 2 stations and 1 transfer' do
          expected << 'Time travel: 2 hours 6 minutes'
          expected << "On line NE, travel from #{source} to Little India, 10 stops"
          expected << "Transfer from line NE to line DT at Little India"
          expected << "On line DT, travel from Little India to #{destination}, 2 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'need to change line many times' do
        let(:source) { 'Punggol' }
        let(:destination) { 'Tampines West' }

        it 'shows detailed fastest route between 2 stations and many transfers' do
          expected << 'Time travel: 2 hours 20 minutes'
          expected << "On line NE, travel from #{source} to Serangoon, 5 stops"
          expected << "Transfer from line NE to line CC at Serangoon"
          expected << "On line CC, travel from Serangoon to MacPherson, 3 stops"
          expected << "Transfer from line CC to line DT at MacPherson"
          expected << "On line DT, travel from MacPherson to #{destination}, 5 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'fastest route contains closed-at-night line' do
        let(:source) { 'Punggol' }
        let(:destination) { 'Bugis' }
        let(:start_time) { '2100-01-01T23:00:00' }

        it 'shows the next fastest route which does not use the closed-line to transfer' do
          expected << 'Time travel: 2 hours 30 minutes'
          expected << "On line NE, travel from #{source} to Dhoby Ghaut, 11 stops"
          expected << "Transfer from line NE to line NS at Dhoby Ghaut"
          expected << "On line NS, travel from Dhoby Ghaut to City Hall, 1 stop"
          expected << "Transfer from line NS to line EW at City Hall"
          expected << "On line EW, travel from City Hall to #{destination}, 1 stop"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'fastest route contains in-construction stations' do
        let(:source) { 'Farrer Park' }
        let(:destination) { 'Novena' }
        let(:start_time) { '2012-01-01T10:00:00' }

        it 'shows the next fastest route which does not use the in-construction stations' do
          expected << 'Time travel: 1 hour 10 minutes'
          expected << "On line NE, travel from #{source} to Dhoby Ghaut, 2 stops"
          expected << "Transfer from line NE to line NS at Dhoby Ghaut"
          expected << "On line NS, travel from Dhoby Ghaut to #{destination}, 4 stops"
          expect { subject }.to output(expected_regex).to_stdout
        end
      end

      context 'source and destination is on the same line, but taking transfers is faster' do
        context 'take one transfer' do
          let(:source) { 'Jurong East' }
          let(:destination) { 'Marina Bay' }

          it 'shows the transfer route instead' do
            expected << 'Time travel: 2 hours 0 minute'
            expected << "On line EW, travel from #{source} to Raffles Place, 10 stops"
            expected << "Transfer from line EW to line NS at Raffles Place"
            expected << "On line NS, travel from Raffles Place to #{destination}, 1 stop"
            expect { subject }.to output(expected_regex).to_stdout
          end

        end

        context 'take more than one transfer' do
          let(:source) { 'Bukit Panjang' }
          let(:destination) { 'Expo' }

          it 'shows the multiple-transfer route instead' do
            expected << 'Time travel: 3 hours 48 minutes'
            expected << "On line DT, travel from #{source} to Botanic Gardens, 7 stops"
            expected << "Transfer from line DT to line CC at Botanic Gardens"
            expected << "On line CC, travel from Botanic Gardens to MacPherson, 8 stops"
            expected << "Transfer from line CC to line DT at MacPherson"
            expected << "On line DT, travel from MacPherson to #{destination}, 9 stops"
            expect { subject }.to output(expected_regex).to_stdout
          end
        end
      end
    end
  end
end
