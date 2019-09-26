require 'journey'

describe Journey do

  subject(:journey) { described_class.new }
  let(:station_a) { double :station_a }
  let(:station_b) { double :station_b }
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

  it 'returns a fare for a complete journey (minimum)' do
    journey.start_journey(station_a)
    journey.end_journey(station_b)
    expect(journey.fare).to eq Journey::MINIMUM_FARE
  end

  it 'has a penatly fare of £6 by defualt' do
    expect(journey.fare).to eq Journey::PENALTY_FARE
  end

  it 'fare will be the penatly fare of £6 by for an incomplete journey' do
    journey.end_journey(station_b)
    expect(journey.fare).to eq Journey::PENALTY_FARE
  end
end
