class Oystercard

  attr_reader :balance, :in_journey
  MAXIMUM_LIMIT = 90

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(value)
    raise "Error: £#{MAXIMUM_LIMIT} exceeded" if @balance + value > MAXIMUM_LIMIT
    @balance += value
  end

  def deduct(value)
    @balance -= value
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise "Error: already on journey" if in_journey?

    @in_journey = true
  end

  def touch_out
    raise "Error: not currently in use" if !in_journey?

    @in_journey = false
  end
end
