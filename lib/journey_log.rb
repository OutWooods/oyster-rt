require_relative "journey"

class JourneyLog
 attr_reader :current_journey

 def initialize(journey = Journey)
   @history = []
   @journey = journey
 end

 def start(entry_station)
   store_journey
   @current_journey = @journey.new(entry_station)
 end

 def end(exit_station)
   unfinished_journey
   @current_journey.end(exit_station)
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
   return @history[-1].fare if @current_journey.nil?
   @current_journey.fare
 end


 private

 def clear_journey  # extract
   @current_journey = nil
 end

 def store_journey #extract
  @history << @current_journey unless @current_journey.nil?
 end

 def unfinished_journey #extract
   @current_journey ||= @journey.new(nil)
 end

end
