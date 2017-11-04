require "spec_helper"

describe Netvice::ConnectionPipeline do
  it 'set basic method to all http verbs' do
    subject = described_class.new
    expect(subject.for).to eq %i[get patch post delete]
  end

  it 'has settable transformable methods' do
    subject = described_class.new(for: ['get', 'post', :patch])
    expect(subject.for).to eq %i[get post patch]
  end

  describe '#for_method' do
    it 'accepts symbol and string' do
      subject = described_class.new(for: ['get', 'post'])
      expect(subject.for_method?(:get)).to be true
      expect(subject.for_method?('get')).to be true
    end
  end

  it 'has default path processor if unassigned that will return itself' do
    subject = described_class.new
    o = Object.new
    path, _ = subject.call(o, nil)
    expect(path).to eq o
  end

  it 'has default body processor if unassigned that will return itself' do
    subject = described_class.new
    o = Object.new
    _, body = subject.call(nil, o)
    expect(body).to eq o
  end
end
