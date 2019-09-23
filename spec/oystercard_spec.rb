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
      oystercard.top_up(Oystercard::MAXIMUM_LIMIT)
      expect{ oystercard.top_up(1) }.to raise_error("Error: over maximum limit")
    end

  end

end
