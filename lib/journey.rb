class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6
  attr_reader :route, :fare

  def initialize
    @fare = PENALTY_FARE
    @route = { entry: nil, exit: nil }
  end

  def start_journey(entry)
    @route[:entry] = entry
  end

  def end_journey(exit)
    @route[:exit] = exit
    calc_fare
  end

  private

  def calc_fare
    @fare = MINIMUM_FARE unless incomplete?
  end

  def incomplete?
    @route[:entry].nil? || @route[:exit].nil?
  end

end
