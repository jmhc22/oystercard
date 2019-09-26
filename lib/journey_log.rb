class JourneyLog

  attr_reader :outstanding_charges

  def initialize(journey_class: Journey)
    @journey_class = journey_class
    @journey = nil
    @history = []
    @outstanding_charges = 0
  end

  def start(entry_station)
    save_journey unless @journey.nil?
    @journey = @journey_class.new
    @journey.start_journey(entry_station)
  end

  def finish(exit_station)
    @journey = @journey_class.new if @journey.nil?
    @journey.end_journey(exit_station)
    save_journey
  end

  def reset_charges
    @outstanding_charges = 0
  end

  def history
    @history.dup
  end

  private

  def save_journey
    @outstanding_charges = @journey.fare
    @history << @journey
    @journey = nil
  end
end
