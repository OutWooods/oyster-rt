require "journey"

describe Journey do
   subject(:journey) {described_class.new}
   let(:start_station) {double("station")}
   let(:exit_station) {double("station")}


   it "should initialize entry_station to nil" do
     expect(journey.entry_station).to be_nil
   end

   it "should initialize exit_station to nil" do
     expect(journey.exit_station).to be_nil
   end

   describe "#complete?" do
     it "should initialise to not not be completed" do
     expect(journey).to_not be_complete
     end

     it "should be complete after entering and exiting" do
       journey.start(start_station)
       journey.end(exit_station)
       expect(journey).to be_complete
     end
   end

   describe "#start" do
     it "should start a journey when called" do
     journey.start(start_station)
     expect(journey.entry_station).to eq start_station
     end
   end

   describe "#end" do
     it "should end a journey when called" do
     journey.end(exit_station)
     expect(journey.exit_station).to eq exit_station
     end
   end

   describe "#started?" do
     it "should be set to not started by default" do
     expect(journey).to_not be_started
     end

     it "once its given entry station it should haved started" do
     journey.start(start_station)
     expect(journey).to be_started
     end
   end

   describe "#fare" do
     it "return mnimum fare" do
       journey.start(start_station)
       journey.end(exit_station)
     expect(journey.fare).to eq Journey::MINIMUM_CHARGE
     end

     it "return penalty fare, when you haven't touched in" do
      journey.end(exit_station)
     expect(journey.fare).to eq Journey::PENALTY_FARE
     end

     it "return penalty fare, when you haven't touched out" do
    journey.start(start_station)
     expect(journey.fare).to eq Journey::PENALTY_FARE
     end
   end
end
