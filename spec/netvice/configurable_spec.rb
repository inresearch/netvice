require "spec_helper"

describe Netvice::Configurable do
  let(:database_config_class) {
    Class.new do
      include Netvice::Configurable

      config_field :cache_endpoint, "http://localhost:5000"
      config_field :timeout
      config_field(:env, 'DEVELOPMENT') do |env|
        env.upcase
      end
      config_field :in_rails, -> { defined?(Rails) ? true : false }

      attr_reader :called

      def setup
        @called = true
      end
    end
  }

  subject { database_config_class.new }

  describe '#initialize' do
    it 'set the default attribute automatically' do
      expect(subject.cache_endpoint).to eq 'http://localhost:5000'
      expect(subject.timeout).to be nil
    end
  end # initialize

  it 'returns the value when no arg is given' do
    expect(subject.cache_endpoint).to eq 'http://localhost:5000'
  end

  it 'set the value when an arg is given' do
    expect(subject.cache_endpoint).to eq 'http://localhost:5000'
    subject.cache_endpoint nil
    expect(subject.cache_endpoint).to be_nil

    expect(subject.timeout).to be_nil
    subject.cache_endpoint 5
    expect(subject.cache_endpoint).to eq 5
  end

  it 'call setup after initialization' do
    expect(subject.called).to be true
  end

  it 'can manipulates the variable if definition has block' do
    expect(subject.env).to eq 'DEVELOPMENT'
    subject.env 'producTiOn'
    expect(subject.env).to eq 'PRODUCTION'
  end

  it 'can evaluate value defined in a proc and execute the block to obtain actual value' do
    conf1 = database_config_class.new
    expect(conf1.in_rails).to be false
    module Rails; end
    conf2 = database_config_class.new
    expect(conf2.in_rails).to be true
    Object.send(:remove_const, :Rails)
    conf3 = database_config_class.new
    expect(conf3.in_rails).to be false
  end
end # Netvice::Configurable
