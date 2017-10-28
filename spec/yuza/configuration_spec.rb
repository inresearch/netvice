require 'spec_helper'

describe Yuza::Configuration do
  let(:configuration) { Netvice.configuration }
  after { Netvice.reset_configuration! }

  it 'initializes by default' do
    expect(configuration.yuza).to be_a Yuza::Configuration
  end

  it 'can change port' do
    expect(configuration.yuza.port).to_not eq 5000
    Netvice.configure do
      yuza do
        port 5000
      end
    end
    expect(configuration.yuza.port).to eq 5000
  end

  it 'can change host' do
    expect(configuration.yuza.host).to_not eq 'http://yuza.com'
    configuration.yuza do
      host 'http://yuza.com'
    end
    expect(configuration.yuza.host).to eq 'http://yuza.com'
  end
end
