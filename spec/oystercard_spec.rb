require 'Oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:station_a) { double :station_a }

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

  describe '#in_journey?' do
    it { expect(oystercard.in_journey?).to eq false }
  end

  describe '#touch_in' do
    it 'starts journey' do
      oystercard.touch_in(station_a)
      expect(oystercard).to be_in_journey
    end

    it 'does not start journey if already on one' do
      oystercard.touch_in(station_a)
      expect { oystercard.touch_in(station_a) }.to raise_error("Error: already on journey")
    end

    it 'prevents entry if minimum balance is less than minimum balance' do
      oystercard = Oystercard.new
      minimum_balance = Oystercard::MINIMUM_BALANCE
      oystercard.top_up(0.5)
      expect { oystercard.touch_in(station_a) }.to raise_error("Error: balance below #{minimum_balance} - please top up")
    end

    it 'oystercard will store the touch in station as a variable' do
      oystercard.touch_in(station_a)
      expect(oystercard.entry_station).to eq station_a
    end
  end

  describe '#touch_out' do
    it 'ends journey' do
      oystercard.touch_in(station_a)
      oystercard.touch_out
      expect(oystercard).to_not be_in_journey
    end

    it 'does not end a journey if not currently on one' do
      expect { oystercard.touch_out }.to raise_error("Error: not currently in use")
    end

    it 'should reduce the balance by the minimum fare' do
      oystercard.touch_in(station_a)
      expect { oystercard.touch_out }.to change { oystercard.balance }.by(Oystercard::MINIMUM_FARE * -1)
    end
  end
end
