require "journey_log"

describe JourneyLog do
   let(:entry_station) {double :station}
   let(:exit_station) {double :station}
   let(:journey) { double :journey, fare: nil }
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
     before do
       allow(journey).to receive(:end)
       journey_log.start(entry_station)
       journey_log.end(exit_station)
     end

    it 'stores a journey'do
      expect(journey_log.history).to include journey
    end

    it 'clears a journey' do
      expect(journey_log.current_journey).to be nil
    end
  end

  describe '#has started' do
    it 'returns false when not in a journey' do
      expect(journey_log).to_not be_started
    end

    it 'returns true when in a journey' do
      journey_log.start(entry_station)
      expect(journey_log).to be_started
    end
  end

  describe '#fare' do
    it 'calls fare on current journey' do
      journey_log.start(entry_station)
      journey_log.fare
      expect(journey).to have_received(:fare)
    end
  end

end
