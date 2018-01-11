require "oystercard"

describe Oystercard do

  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let(:journey) {double :journey}
  let(:penalty) {5}
  subject(:subject) {described_class.new(journey)}

  before do
   allow(journey).to receive(:new).and_return(journey)
   allow(journey).to receive(:started?)
  end

  it 'sets zero balance on new oystercard' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do

    it 'can top up the balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it 'raises error when balance excedes balance limit' do
      balance_limit = Oystercard::BALANCE_LIMIT
      subject.top_up(balance_limit)
      message = "Balance limit of #{balance_limit} reached"
      expect{subject.top_up(1)}.to raise_error message
    end
  end
  describe '#touch_in' do
    before do
      allow(journey).to receive(:start).with(entry_station)
    end

    it 'raises error when touched in card has insufficient balance'do
      expect{subject.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end

    it 'checks if journey is started, and calls fare if it has already'do
      allow(journey).to receive(:started?).and_return false
      allow(journey).to receive(:fare).and_return(5)
      expect{subject.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end

    it 'creates a new journey'do
      allow(journey).to receive(:new).and_return(journey)
      expect{subject.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end
  end

  describe '#touch_out'do
    before do
      subject.top_up(penalty)
      allow(journey).to receive(:end).with(exit_station)
      allow(journey).to receive(:fare).and_return(penalty)
    end

    it "charges fare when you touched out" do
      expect{ subject.touch_out(exit_station)}.to change{subject.balance}.by(-5)
    end

    it 'stores a journey'do
      allow(journey).to receive(:new).and_return(journey)
      expect(subject.journeys).to include journey
    end

    it 'creates a new journey object'do
      allow(journey).to receive(:new).and_return(journey)
      expect(subject.touch_out(exit_station)).to eq journey
    end
  end

    describe 'journeys' do
      it 'card should have empty list of journeys by default'do
        expect(subject.journeys).to eq []
      end
    end
  end
