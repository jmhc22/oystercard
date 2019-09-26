require 'journey_log'

describe JourneyLog do

  let(:station_a) { double :station_a }
  let(:station_b) { double :station_b }

  let(:complete_journey) { { entry: station_a, exit: station_b } }
  let(:journey) { double :journey, start_journey: nil, end_journey: nil, route: complete_journey, fare: 1 }
  let(:journey_class) { double :journey_class, new: journey }

  let(:incomplete_journey1) { { entry: nil, exit: station_b } }
  let(:inc_journey1) { double :inc_journey, start_journey: nil, end_journey: nil, route: incomplete_journey1, fare: 6 }
  let(:inc_journey_class1) { double :inc_journey_class, new: inc_journey1 }

  let(:incomplete_journey2) { { entry: nil, exit: station_b } }
  let(:inc_journey2) { double :inc_journey, start_journey: nil, end_journey: nil, route: incomplete_journey2, fare: 6 }
  let(:inc_journey_class2) { double :inc_journey_class, new: inc_journey2 }

  subject(:journey_log) { described_class.new(journey_class: journey_class) }

  describe '#start' do
    it 'starting a journey without ending curreny will save incomplete journey to history' do
      journey_log = JourneyLog.new(journey_class: inc_journey_class1)
      journey_log.start(station_a)
      journey_log.start(station_a)
      expect(journey_log.history[-1].route).to eq incomplete_journey1
    end

    it 'starting a journey without ending a journey will set outstanding_charges to £6' do
      journey_log = JourneyLog.new(journey_class: inc_journey_class1)
      journey_log.start(station_a)
      expect{ journey_log.start(station_a) }.to change{ journey_log.outstanding_charges }.by(6)
    end
  end

  describe '#finish' do
    it 'touching out witout touching in will return an imcomplete journey to the array' do
      journey_log = JourneyLog.new(journey_class: inc_journey_class2)
      journey_log.start(station_a) #using double so just inserting this here
      journey_log.finish(station_b)
      expect(journey_log.history[-1].route).to eq incomplete_journey2
    end

    it 'touching out witout touching in will result in £6 penalty fare' do
      journey_log = JourneyLog.new(journey_class: inc_journey_class2)
      journey_log.start(station_a) #using double so just inserting this here
      expect{ journey_log.finish(station_b) }.to change{ journey_log.outstanding_charges }.by(6)
    end

    it 'stores a hash of a complete journey on touch out in an array' do
      journey_log.start(station_a)
      journey_log.finish(station_b)
      expect(journey_log.history[-1].route).to eq complete_journey
    end
  end
end
