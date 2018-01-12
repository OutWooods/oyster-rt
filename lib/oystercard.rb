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
    @journeys.start(station)
  end

  def touch_out(exit_station)
    close_journey(exit_station)  #extract
  end

  private

  def create_journey(station=nil)
    @journey.new(station)   #extract
  end

  def close_journey(exit_station=nil)  #extract
    current_journey.end(exit_station) #
    deduct(@current_journey.fare)
    store_journey(@current_journey) #
    clear_journey #
  end

  def clear_journey  # extract
    @current_journey = nil
  end

  def current_journey #extract
    @current_journey ||= create_journey
  end

  def store_journey(journey) #extract
    @journeys << journey
  end

  def penalty? #extract
    !!@current_journey
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


end
