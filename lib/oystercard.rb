class Oystercard

  attr_reader :balance
  MAXIMUM_LIMIT = 90

  def initialize
    @balance = 0
  end

  def top_up(value)
    raise "Error: over maximum limit" if @balance + value > MAXIMUM_LIMIT
    @balance += value
  end

end
