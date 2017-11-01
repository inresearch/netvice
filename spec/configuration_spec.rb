require "spec_helper"

describe Netvice::Configuration do
  let(:configuration) { Netvice.configuration }
  after { Netvice.reset_configuration! }

  it 'can change app' do
    expect(configuration.app).to_not eq 'pageok'
    configuration.instance_eval do
      app 'pageok'
    end
    expect(configuration.app).to eq 'pageok'
  end

  it 'can return project configurer' do
    expect(Netvice.configuration.dero).to be_a Netvice::Dero::Configuration
    expect(Netvice.configuration.yuza).to be_a Netvice::Yuza::Configuration
  end
end
