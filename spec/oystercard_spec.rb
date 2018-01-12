require "oystercard"

describe Oystercard do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journeylog) { double :JourneyLog, start: journey, fare: amount }
  let(:amount) {5}
  let(:journey) { double :journey }

  subject(:oystercard) {described_class.new(journeylog)}

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
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      message = "Balance limit of #{Oystercard::BALANCE_LIMIT} reached"
      expect{ oystercard.top_up(1) }.to raise_error message
    end
  end

  describe '#touch_in' do


    it 'raises error when touched in card has insufficient balance'do
      expect{oystercard.touch_in(entry_station)}.to raise_error 'Insufficient balance'
    end

    it 'charges penalty fare if you touch in twice in a row' do
      allow(journeylog).to receive(:started?).and_return true
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_in(entry_station)}.to change{ oystercard.balance }.by -amount
    end

    it 'creates a new journey' do
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      allow(journeylog).to receive(:started?).and_return false
      expect(oystercard.touch_in(entry_station)).to eq journey
    end

  end

  describe '#touch_out'do
    before do
      oystercard = described_class.new(journeylog, Oystercard::BALANCE_LIMIT)
      allow(journeylog).to receive(:end).with(exit_station)
    end

    it "charges fare when you touched out" do
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-amount)
    end

  end

  end
