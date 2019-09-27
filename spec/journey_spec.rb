require 'journey'

describe Journey do

  subject(:journey) { described_class.new }
  let(:station_a) { double :station_a, zone: 1 }
  let(:station_b) { double :station_b, zone: 3 }
  let(:station_c) { double :station_b, zone: 5 }
  let(:complete_journey) { { entry: station_a, exit: station_b } }


  it 'starts a journey with an entry station saved' do
    journey.start_journey(station_a)
    expect(journey.route[:entry]).to eq station_a
  end

  it 'finishes a journey and returns complete journey' do
    journey.start_journey(station_a)
    journey.end_journey(station_b)
    expect(journey.route).to eq complete_journey
  end

  it 'has a penatly fare of £6 by defualt' do
    expect(journey.fare).to eq Journey::PENALTY_FARE
  end

  it 'fare will be the penatly fare of £6 by for an incomplete journey' do
    journey.end_journey(station_b)
    expect(journey.fare).to eq Journey::PENALTY_FARE
  end

  describe 'calc_fare' do
    it 'going from zone 1 to zone 1 will cost £1' do
      journey.start_journey(station_a)
      expect{ journey.end_journey(station_a) }.to change{ journey.fare }.by(-5)
    end

    it 'going from zone 1 to zone 5 will cost £5' do
      journey.start_journey(station_a)
      expect{ journey.end_journey(station_c) }.to change{ journey.fare }.by(-1)
    end

    it 'going from zone 3 to zone 1 will cost £3' do
      journey.start_journey(station_b)
      expect{ journey.end_journey(station_a) }.to change{ journey.fare }.by(-3)
    end
  end
end
