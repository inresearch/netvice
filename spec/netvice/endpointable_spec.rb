require "spec_helper"

describe Netvice::Endpointable do
  let(:database_config_class) {
    Class.new do
      include Netvice::Endpointable
    end
  }

  subject { database_config_class.new }

  describe '#base_url' do
    it 'has no trailing /' do
      expect(subject.base_url).to_not end_with('?')
      subject.host 'http://myapp.com/'
      expect(subject.host).to eq 'http://myapp.com'
      expect(subject.base_url).to eq 'http://myapp.com:2000'
    end
  end

  it '#user_agent' do
    Netvice.conf.reset!
    expect(subject.user_agent).to eq "netvice #{Netvice::VERSION}"
    Netvice.conf.app 'pageok'
    expect(subject.user_agent).to eq "netvice #{Netvice::VERSION}/pageok"
    Netvice.conf.reset!
  end
end
