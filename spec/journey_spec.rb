require "journey"

describe Journey do
   let(:start_station) {double("station", zone: 1)}
   let(:exit_station) {double("station", zone: 1)}
   subject(:journey) {described_class.new(start_station)}



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
     it "return mnimum fare for same zone" do
       journey.end(exit_station)
       expect(journey.fare).to eq Journey::MINIMUM_CHARGE
     end

     it "returns fare of Minimum + 1 for a zone one station and zone two station" do
       allow(exit_station).to receive(:zone).and_return(2)
       journey.end(exit_station)
       expect(journey.fare).to eq Journey::MINIMUM_CHARGE + Journey::INCREMENT
     end

     it "returns fare of Minimum + 2 for a zone five station and zone three station" do
       allow(start_station).to receive(:zone).and_return(5)
       allow(exit_station).to receive(:zone).and_return(3)
       journey.end(exit_station)
       expect(journey.fare).to eq Journey::MINIMUM_CHARGE + (Journey::INCREMENT * 2)
     end

     it "return penalty fare, when you haven't touched out" do
     expect(journey.fare).to eq Journey::PENALTY_FARE
     end
   end
end
