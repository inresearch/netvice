require "spec_helper"

describe Netvice::Configuration do
  subject { Netvice.configuration }
  after { Netvice.reset_configuration! }

  describe '#logger' do
    context 'no rails' do
      it 'initiates standard logger' do
        conf = Netvice::Configuration.new
        expect(conf.logger).to be_a Logger
      end
    end

    context 'within rails' do
      it 'initiates to rails' do
        module Rails
          LOGGER = Object.new
          extend self
          def logger
            LOGGER
          end
        end

        conf = Netvice::Configuration.new
        expect(conf.logger).to eq Rails::LOGGER
        Object.send(:remove_const, :Rails)
      end
    end
  end

  it 'has yuza configuration' do
    expect(subject.yuza).to be_a Netvice::Yuza::Configuration
    expect(Netvice::Yuza::Configuration).to include Netvice::Configurable
  end

  it 'can change app' do
    expect(subject.app).to_not eq 'pageok'
    subject.instance_eval do
      app 'pageok'
    end
    expect(subject.app).to eq 'pageok'
  end

  it 'can return project configurer' do
    expect(subject.dero).to be_a Netvice::Dero::Configuration
    expect(subject.yuza).to be_a Netvice::Yuza::Configuration
  end
end
