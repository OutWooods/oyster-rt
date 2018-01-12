require_relative "journey"

class JourneyLog
 attr_reader :current_journey

 def initialize(journey = Journey)
   @history = []
   @journey = journey
 end

 def start(entry_station)
   @current_journey = @journey.new(entry_station)
 end

 def end(exit_station)
   store_journey
   clear_journey
 end

 def history
   @history.dup
 end

 def started?
   @current_journey != nil
 end

 def fare
   @current_journey.fare
 end


 private

 def clear_journey  # extract
   @current_journey = nil
 end

 def store_journey #extract
   @history << @current_journey
 end

end
