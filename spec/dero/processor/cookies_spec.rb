require "spec_helper"

describe Netvice::Dero::Processor::Cookies do
  subject { described_class }
  let(:mask) { Netvice::Dero::Processor::STRING_MASK }

  let(:cookies) {{
    'request' => {
      'headers' => {
        'Cookie' => '_dero_testapp_session=SlrK29NhZaMNbC382Av',
        'OtherHeader' => 'still_here'
      },
      'cookies' => '_dero_testapp_session=SlrK29NhZaMNbC382Av',
      'other_data' => 'still_here'
    }
  }}

  it 'masks cookies' do
    subject.process!(cookies)
    expect(cookies['request']['cookies']).to eq mask
    expect(cookies['request']['headers']['Cookie']).to eq mask
    expect(cookies['request']['other_data']).to eq 'still_here'
    expect(cookies['request']['headers']['OtherHeader']).to eq 'still_here'
  end

  context 'cookies symbolized' do
    it 'masks cookies' do
      result = Netvice::Transformer::Hash.deep_symbolize_keys(cookies)
      subject.process!(result)
      expect(result[:request][:cookies]).to eq mask
      expect(result[:request][:headers][:'Cookie']).to eq mask
      expect(result[:request][:other_data]).to eq 'still_here'
      expect(result[:request][:headers][:'OtherHeader']).to eq 'still_here'
    end
  end
end # Netvice::Dero::Processor::Cookies
