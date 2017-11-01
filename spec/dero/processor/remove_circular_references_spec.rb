require "spec_helper"

describe Dero::Processor::RemoveCircularReferences do
  subject { described_class }
  let(:mask) { '(...)' }

  it 'removes circular references' do
    data = {}
    data['data'] = data
    data['ary'] = []
    data['ary'].push('x' => data['ary'])
    data['ary2'] = data['ary']
    data['leave intact'] = {'not a circ ref' => true}

    subject.process!(data)
    expect(data['data']).to eq mask
    expect(data['ary'].first['x']).to eq mask
    expect(data['ary2']).to eq mask
    expect(data['leave intact']).to eq({'not a circ ref' => true})
  end
end
