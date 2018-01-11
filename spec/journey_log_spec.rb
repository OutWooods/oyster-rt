require "journey_log"

describe JourneyLog do
   let(:entry_station) {double :station}
  let(:exit_station) {double :station}
   let(:journey) {double :journey}
   let (:journey_class) { double :journey_class, new: journey }
   subject(:journey_log) {described_class.new(journey_class)}

   describe "#initialize" do
      it 'card should have empty list of history by default'do
        expect(journey_log.history).to eq []
      end
   end

   describe "#start" do
     it 'should start a new journey' do
        expect(journey_log.start(entry_station)).to eq journey
     end
   end

   describe "#end" do
    it 'stores a journey'do
      journey_log.start(entry_station)
      journey_log.end(exit_station)
      expect(journey_log.history).to include journey
    end

    it 'clears a journey' do
      journey_log.start(entry_station)
      journey_log.end(exit_station)
      expect(journey_log.history).to include journey
    end

   end
end
