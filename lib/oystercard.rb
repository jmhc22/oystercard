class Oystercard

  attr_reader :balance, :entry_station, :journey_history
  MAXIMUM_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journey_history = []
  end

  def top_up(value)
    raise "Error: £#{MAXIMUM_LIMIT} exceeded" if exceed_cap?(value)
    @balance += value
  end

  def in_journey?
    @entry_station ? true : false
  end

  def touch_in(entry_station)
    raise "Error: balance below #{MINIMUM_BALANCE} - please top up" if insufficient_funds?
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @journey_history << { entry: @entry_station, exit: exit_station }
    @entry_station = nil
  end

  private

  def deduct(value)
    @balance -= value
  end

  def exceed_cap?(value)
    @balance + value > MAXIMUM_LIMIT
  end

  def insufficient_funds?
    @balance < MINIMUM_BALANCE
  end

end
