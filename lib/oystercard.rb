class Oystercard

  attr_reader :balance, :in_journey, :entry_station
  MAXIMUM_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
  end

  def top_up(value)
    raise "Error: £#{MAXIMUM_LIMIT} exceeded" if exceed_cap?(value)
    @balance += value
  end

  def in_journey?
    @entry_station ? true : false
  end

  def touch_in(entry_station)
    raise "Error: already on journey" if in_journey?
    raise "Error: balance below #{MINIMUM_BALANCE} - please top up" if @balance < MINIMUM_BALANCE
    @entry_station = entry_station
    @in_journey = true
  end

  def touch_out
    raise "Error: not currently in use" if !in_journey?
    deduct(MINIMUM_FARE)
    @entry_station = nil
    @in_journey = false
  end

  private

  def deduct(value)
    @balance -= value
  end

  def exceed_cap?(value)
    @balance + value > MAXIMUM_LIMIT
  end

end
