require "spec_helper"

describe Netvice::Timestampable do
  let(:person_class) {
    Class.new do
      include Netvice::Timestampable
    end
  }

  subject { person_class.new }

  it 'convert from timestamp for created_at and updated_at' do
    timestamp = 15000000
    subject.created_at = 150_000_000_000
    subject.updated_at = 170_000_000_000
    expect(subject.created_at.to_s).to eq '6723-04-25 09:40:00 +0700'
    expect(subject.updated_at.to_s).to eq '7357-01-31 21:13:20 +0700'
  end
end
