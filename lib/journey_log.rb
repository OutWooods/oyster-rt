class JourneyLog
 attr_reader :history, :current_journey

 def initialize(journey)
   @history = []
   @journey = journey
 end

 def start(entry_station)
   @current_journey = @journey.new
 end

 def end(exit_station)
   @history << @current_journey
 end

end
