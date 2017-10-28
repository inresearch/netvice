require "spec_helper"

describe Netvice::Configurable do
  class DatabaseConfig
    include Netvice::Configurable

    config_field :cache_endpoint, "http://localhost:5000"
    config_field :timeout
    config_field(:env, 'DEVELOPMENT') do |env|
      env.upcase
    end

    attr_reader :called

    def setup
      @called = true
    end
  end

  subject { DatabaseConfig.new }

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
end # Netvice::Configurable
