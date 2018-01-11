require "oystercard"

describe Oystercard do

  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let (:journey_class) { double :journey_class, new: journey }
  let(:journey) {double :journey}
  let(:penalty) {5}
  subject(:oystercard) {described_class.new(journey_class)}

  describe "#initialize" do
    it 'sets zero balance on new oystercard' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'can top up the balance' do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    it 'raises error when balance excedes balance limit' do
      oystercard = described_class.new(journey, Oystercard::BALANCE_LIMIT)
      message = "Balance limit of #{Oystercard::BALANCE_LIMIT} reached"
      expect{ oystercard.top_up(1) }.to raise_error message
    end

  end
  describe '#touch_in' do
    before do
      allow(journey).to receive(:start).with(entry_station)
      allow(journey).to receive(:end)
    end

    it 'raises error when touched in card has insufficient balance'do
      expect{oystercard.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end

    it 'charges penalty fare if entered twice' do
      allow(journey).to receive(:fare).and_return(5)
      oystercard = described_class.new(journey_class, Oystercard::BALANCE_LIMIT)
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_in(entry_station)}.to change{ oystercard.balance }.by -5
    end

  end

  describe '#touch_out'do
    before do
      oystercard = described_class.new(journey_class, Oystercard::BALANCE_LIMIT)
      allow(journey).to receive(:end).with(exit_station)
      allow(journey).to receive(:fare).and_return(penalty)
    end

    it "charges fare when you touched out" do
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-5)
    end

    it 'stores a journey'do
    oystercard.touch_out(exit_station)
    expect(oystercard.journeys).to include journey
    end

  end
    describe 'journeys' do
      it 'card should have empty list of journeys by default'do
        expect(oystercard.journeys).to eq []
      end
    end
  end
