require 'Oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe '#balance' do
    it { expect(oystercard.balance).to eq 0 }
  end

end
