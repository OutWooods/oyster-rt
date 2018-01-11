require_relative "station"

class Journey
   PENALTY_FARE = 6
   MINIMUM_CHARGE = 1

   attr_reader :entry_station, :exit_station


  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def fare
    return PENALTY_FARE unless complete?
    MINIMUM_CHARGE
  end

  def start(entry_station)
    @entry_station = entry_station
  end

  def end(exit_station)
    @exit_station = exit_station
  end

  def started?
    !!@entry_station
  end

  def complete?
    (@entry_station.nil? || @exit_station.nil?) ? false : true
  end


end
