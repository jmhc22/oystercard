require_relative 'station'
require_relative 'journey'

class Oystercard

  attr_reader :balance, :journey_history, :journey
  MAXIMUM_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize(journey_class: Journey)
    @balance = 0
    @journey_history = []
    @journey_class = journey_class
    @journey = nil
  end

  def top_up(value)
    raise "Error: £#{MAXIMUM_LIMIT} exceeded" if exceed_cap?(value)
    @balance += value
  end

  def touch_in(entry_station)
    raise "Error: balance below #{MINIMUM_BALANCE} - please top up" if insufficient_funds?
    double_touch_in unless @journey.nil?
    initiate_journey(entry_station)
  end

  def touch_out(exit_station)
    no_touch_in if @journey.nil?
    @journey.end_journey(exit_station)
    deduct(@journey.fare)
    save_journey
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

  def double_touch_in
    deduct(@journey.fare)
    save_journey
  end

  def no_touch_in
    @journey = @journey_class.new
  end

  def initiate_journey(entry_station)
    @journey = @journey_class.new
    @journey.start_journey(entry_station)
  end

  def save_journey
    @journey_history << @journey
    @journey = nil
  end
end
