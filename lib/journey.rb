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
    @fare = zone_fare unless incomplete?
  end

  def incomplete?
    @route[:entry].nil? || @route[:exit].nil?
  end

  def zone_fare
    ([@route[:entry].zone, @route[:exit].zone].sort.reverse.inject(:-)) + 1
  end

end
