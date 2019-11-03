require 'spec_helper'

describe RoutesFinder do
  before(:all) do
    network = Network.new(TEST_DATA_FILE)
    @routes_finder = RoutesFinder.new(network, Time.new(2100, 1, 1))
  end

  describe '#find' do
    context 'no route found' do

    end

    context 'source and destination stations are identical' do

    end

    context 'only one-step route' do

    end

    context 'multiple-step route' do

    end
  end
end
