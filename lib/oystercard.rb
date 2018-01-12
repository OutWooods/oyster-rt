require_relative 'journey_log'

class Oystercard
attr_reader :balance, :journeys

BALANCE_LIMIT = 90
MINIMUM_FARE = 1

  def initialize(journey_log = JourneyLog.new, balance = 0)
   @balance = balance
   @journeys = journey_log
  end

  def top_up(amount)
    raise "Balance limit of #{BALANCE_LIMIT} reached" if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficient balance" unless enough_money?
    deduct(journeys.fare) if @journeys.started?
    @journeys.start(station)
  end

  def touch_out(exit_station)
    @journeys.end(exit_station)
    deduct(@journeys.fare)  #extract
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def enough_money?
    balance > MINIMUM_FARE
  end

  def limit_exceeded?(amount)
    amount + balance > BALANCE_LIMIT
  end


end
