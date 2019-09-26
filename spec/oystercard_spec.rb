require 'Oystercard'

describe Oystercard do
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

  subject(:oystercard) { described_class.new(journey_class: journey_class) }

  before(:each) do
    oystercard.top_up(10)
  end

  describe '#balance' do
    it { expect(oystercard.balance).to eq 10 }
  end

  describe '#top_up' do
    it 'tops up the oystercard balance by 50' do
      old_balance = oystercard.balance
      top_up_balance = 50
      oystercard.top_up(top_up_balance)
      expect(oystercard.balance).to eq top_up_balance + old_balance
    end

    it 'sets a maximum limit of 90' do
      oystercard = Oystercard.new
      maximum_balance = Oystercard::MAXIMUM_LIMIT
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up(1) }.to raise_error("Error: £#{maximum_balance} exceeded")
    end
  end

  describe '#touch_in' do
    it 'starts a journey' do
      oystercard.touch_in(station_a)
      expect(oystercard.journey).to eq journey
    end

    it 'prevents entry if minimum balance is less than minimum balance' do
      oystercard = Oystercard.new
      minimum_balance = Oystercard::MINIMUM_BALANCE
      oystercard.top_up(0.5)
      expect { oystercard.touch_in(station_a) }.to raise_error("Error: balance below #{minimum_balance} - please top up")
    end

    it 'touching in twice will save an incomplete journey to the journey history' do
      oystercard = Oystercard.new(journey_class: inc_journey_class1)
      oystercard.top_up(50)
      oystercard.touch_in(station_a)
      oystercard.touch_in(station_a)
      expect(oystercard.journey_history[-1].route).to eq incomplete_journey1
    end

    it 'touching in twice will charge £6 penalty fare' do
      oystercard = Oystercard.new(journey_class: inc_journey_class1)
      oystercard.top_up(50)
      oystercard.touch_in(station_a)
      expect{ oystercard.touch_in(station_a) }.to change{ oystercard.balance }.by(-6)
    end
  end

  describe '#touch_out' do
    it 'ends journey' do
      oystercard.touch_in(station_a)
      oystercard.touch_out(station_b)
      expect(oystercard.journey).to eq nil
    end

    it 'should reduce the balance by the minimum fare' do
      oystercard.touch_in(station_a)
      expect { oystercard.touch_out(station_b) }.to change { oystercard.balance }.by(Oystercard::MINIMUM_FARE * -1)
    end

    it 'touching out witout touching in will return an imcomplete journey to the array' do
      oystercard = Oystercard.new(journey_class: inc_journey_class2)
      oystercard.top_up(50)
      oystercard.touch_in(station_a) #using double so just inserting this here
      oystercard.touch_out(station_b)
      expect(oystercard.journey_history[-1].route).to eq incomplete_journey2
    end

    it 'touching out witout touching in will result in £6 penalty fare' do
      oystercard = Oystercard.new(journey_class: inc_journey_class2)
      oystercard.top_up(50)
      oystercard.touch_in(station_a) #using double so just inserting this here
      expect{ oystercard.touch_out(station_b) }.to change{ oystercard.balance }.by(-6)
    end

    it 'stores a hash of a complete journey on touch out in an array' do
      oystercard.touch_in(station_a)
      oystercard.touch_out(station_b)
      expect(oystercard.journey_history[-1].route).to eq complete_journey
    end
  end
end
