require "spec_helper"

describe Netvice::Configuration do
  let(:configuration) { Netvice.configuration }

  it 'initializes by default' do
    expect(configuration.yuza).to be_a Yuza::Configuration
  end

  describe '#yuza' do
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

  it 'can change app' do
    expect(configuration.app).to_not eq 'pageok'
    configuration.instance_eval do
      app 'pageok'
    end
    expect(configuration.app).to eq 'pageok'
  end
end
