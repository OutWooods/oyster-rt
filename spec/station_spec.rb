require 'station'

describe Station do
  subject(:station) {described_class.new( "bank", 1)}

  it'checks name'do
    expect(station.name).to eq "bank"
  end

  it'checks zone'do
    expect(station.zone).to eq 1
  end
end
