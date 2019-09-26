require 'station'

describe Station do

  subject(:station) { described_class.new(name: "Test Station", zone: 1) }

  describe '#initialize' do
    it 'stores a name variable on initialize' do
      expect(station.name).to eq "Test Station"
    end

    it 'stores a name variable on initialize' do
      expect(station.zone).to eq 1
    end
  end
end
