require_relative 'journey'

class Oystercard
attr_reader :balance,:journeys

BALANCE_LIMIT = 90
MINIMUM_BALANCE = 1
MINIMUM_CHARGE = 1

  def initialize(journey = Journey)
   @balance = 0
   @journeys = []
   @journey = journey
   @current_journey = @journey.new
  end

  def top_up(amount)
    raise "Balance limit of #{BALANCE_LIMIT} reached" if amount +balance > BALANCE_LIMIT
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficient balance" unless enough_money?
    return deduct(fare) if penalty?
    @current_journey.start(station)
  end

  def touch_out(exit_station)
    @current_journey.end(exit_station)
    deduct(@current_journey.fare)
    @journeys << @current_journey
    @current_journey = @journey.new
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def enough_money?
    @balance > MINIMUM_BALANCE
  end

  def penalty?
    @current_journey.started?
  end
end
