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

  context 'options are valid' do

  end
end
