require 'Oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe '#balance' do
    it { expect(oystercard.balance).to eq 0 }
  end

  describe '#top_up' do
    it 'tops up the oystercard balance by 50' do
      old_balance = oystercard.balance
      top_up_balance = 50
      oystercard.top_up(top_up_balance)

      expect(oystercard.balance).to eq top_up_balance + old_balance
    end

    it 'sets a maximum limit of 90' do
      maximum_balance = Oystercard::MAXIMUM_LIMIT
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up(1) }.to raise_error("Error: £#{maximum_balance} exceeded")
    end
  end

  describe '#deduct' do
    it 'deducts £10 from the oystercard balance' do
      oystercard.top_up(50)
      oystercard.deduct(10)
      expect(oystercard.balance).to eq 40
    end
  end

  describe '#in_journey?' do
    it { expect(oystercard.in_journey).to eq false }
  end

  describe 'touch_in' do
    it 'starts journey' do
      oystercard.touch_in
      expect(oystercard).to be_in_journey
    end
    it 'does not start journey if already on one' do
      oystercard.touch_in
      expect { oystercard.touch_in }.to raise_error("Error: already on journey")
    end
  end

  describe 'touch_out' do
    it 'ends journey' do
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard).to_not be_in_journey
    end
    it 'does not end a journey if not currently on one' do
      expect { oystercard.touch_out }.to raise_error("Error: not currently in use")
    end
  end

end
