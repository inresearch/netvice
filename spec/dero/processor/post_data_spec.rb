require "spec_helper"

describe Netvice::Dero::Processor::PostData do
  subject { described_class }
  let(:mask) { Netvice::Dero::Processor::STRING_MASK }

  let(:request) {{
    'request' => {
      'method' => 'POST',
      'data' => {
        'sensitive_stuff' => 'i love you'
      }
    }
  }}

  it 'masks data' do
    subject.process!(request)
    expect(request['request']['data']).to eq mask
  end

  context 'headers symbolized' do
    it 'masks data' do
      result = Netvice::Transformer::Hash.deep_symbolize_keys(request)
      subject.process!(result)
      expect(result[:request][:data]).to eq mask
    end
  end
end
