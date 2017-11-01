require "spec_helper"

describe Netvice::Configuration do
  subject { described_class.new }

  it 'initiates logger' do
    expect(subject.logger).to be_a Logger
  end

  it 'has yuza configuration' do
    expect(subject.yuza).to be_a Netvice::Yuza::Configuration
    expect(Netvice::Yuza::Configuration).to include Netvice::Configurable
  end
end
