require "journey"

describe Journey do
   let(:start_station) {double("station")}
   subject(:journey) {described_class.new(start_station)}
   let(:exit_station) {double("station")}


   it "should initialize entry_station to nil" do
     expect(journey.entry_station).to eq (start_station)
   end

   it "should initialize exit_station to nil" do
     expect(journey.exit_station).to be_nil
   end

   describe "#complete?" do
     it "should initialise to not not be completed" do
     expect(journey).to be_incomplete
     end

     it "should be complete after entering and exiting" do
       journey.end(exit_station)
       expect(journey).to_not be_incomplete
     end
   end


   describe "#end" do
     it "should end a journey when called" do
     journey.end(exit_station)
     expect(journey.exit_station).to eq exit_station
     end

     it "should return self when journey ends" do
     expect( journey.end(exit_station)).to eq journey
     end
   end


   describe "#fare" do
     it "return mnimum fare" do
       journey.end(exit_station)
       expect(journey.fare).to eq Journey::MINIMUM_CHARGE
     end

     it "return penalty fare, when you haven't touched out" do
     expect(journey.fare).to eq Journey::PENALTY_FARE
     end
   end
end
