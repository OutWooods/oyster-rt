require_relative 'journey'

class Oystercard
attr_reader :balance,:journeys

BALANCE_LIMIT = 90
MINIMUM_FARE = 1

  def initialize(journey = Journey, balance = 0)
   @balance = balance
   @journeys = []
   @journey = journey
  end

  def top_up(amount)
    raise "Balance limit of #{BALANCE_LIMIT} reached" if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficient balance" unless enough_money?
    close_journey if @current_journey
    @current_journey = create_journey(station)
  end

  def touch_out(exit_station)
    close_journey(exit_station)
  end

  private

  def create_journey(station=nil)
    @journey.new(station)
  end

  def close_journey(exit_station=nil)
    current_journey.end(exit_station)
    deduct(@current_journey.fare)
    store_journey(@current_journey)
    clear_journey
  end

  def clear_journey
    @current_journey = nil
  end

  def current_journey
    @current_journey ||= create_journey
  end

  def store_journey(journey)
    @journeys << journey
  end

  def deduct(amount)
    @balance -= amount
  end

  def enough_money?
    balance > MINIMUM_FARE
  end

  def limit_exceeded?(amount)
    amount + balance > BALANCE_LIMIT
  end

  def penalty?
    !!@current_journey
  end
end
