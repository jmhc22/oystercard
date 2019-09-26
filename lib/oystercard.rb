require_relative 'station'
require_relative 'journey_log'
require_relative 'journey'

class Oystercard
  attr_reader :balance, :journey_log
  MAXIMUM_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize(journey_log_class: JourneyLog)
    @balance = 0
    @journey_log_class = journey_log_class
    @journey_log = @journey_log_class.new
  end

  def top_up(value)
    raise "Error: £#{MAXIMUM_LIMIT} exceeded" if exceed_cap?(value)
    @balance += value
  end

  def touch_in(entry_station)
    raise "Error: balance below #{MINIMUM_FARE} - please top up" if insufficient_funds?
    @journey_log.start(entry_station)
    deduct(@journey_log.outstanding_charges)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(@journey_log.outstanding_charges)
  end

  private

  def deduct(value)
    @balance -= value
    @journey_log.reset_charges
  end

  def exceed_cap?(value)
    @balance + value > MAXIMUM_LIMIT
  end

  def insufficient_funds?
    @balance < MINIMUM_FARE
  end
end
