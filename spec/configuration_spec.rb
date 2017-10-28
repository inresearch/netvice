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
end
