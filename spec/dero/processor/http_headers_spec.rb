require "spec_helper"

describe Netvice::Dero::Processor::HttpHeaders do
  subject { described_class }
  let(:mask) { Netvice::Dero::Processor::STRING_MASK }

  before do
    Netvice.conf.dero.masked_http_headers ['Authorization', 'User-Defined-Header']
  end

  let(:headers) {{
    'request' => {
      'headers' => {
        'Authorization' => 'dontseeme',
        'AnotherHeader' => 'visible',
        'User-Defined-Header' => 'dontseemealso'
      }
    }
  }}

  it 'masks headers' do
    subject.process!(headers)
    expect(headers['request']['headers']['Authorization']).to eq mask
    expect(headers['request']['headers']['AnotherHeader']).to eq 'visible'
    expect(headers['request']['headers']['User-Defined-Header']).to eq mask
  end

  context 'headers symbolized' do
    it 'masks headers' do
      result = Netvice::Transformer::Hash.deep_symbolize_keys(headers)
      subject.process!(result)
      expect(result[:request][:headers][:Authorization]).to eq mask
      expect(result[:request][:headers][:AnotherHeader]).to eq 'visible'
      expect(result[:request][:headers][:'User-Defined-Header']).to eq mask
    end
  end
end # Netvice::Dero::Processor::HttpHeaders
