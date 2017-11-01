require "spec_helper"

describe Dero::Processor::Utf8 do
  subject { described_class }
  let(:text) { "invalid utf8 string goes here\255".force_encoding('UTF-8') }
  let(:clean_text) { 'invalid utf8 string goes here' }

  it 'has a utf8 fixture which is not a valid utf-8' do
    expect(text).to_not be_valid_encoding
    expect { text.match("") }.to raise_error(ArgumentError)
  end

  it 'should cleanup invalid UTF-8 bytes' do
    data = {}
    data['invalid'] = text
    subject.process!(data)
    expect(data['invalid']).to eq clean_text
  end

  it 'should keep valid UTF-8 bytes after cleaning' do
    data = {}
    data['invalid'] = "한국, 中國, 日本(にっぽん)\255".force_encoding('UTF-8')
    subject.process!(data)
    expect(data['invalid']).to eq("한국, 中國, 日本(にっぽん)")
  end

  it 'should work recusively on hashes' do
    data = {nested: {}}
    data[:nested][:invalid] = text
    subject.process!(data)
    expect(data[:nested][:invalid]).to eq clean_text
  end

  it 'should work recursively on arrays' do
    data = ['good string', 'good string', text, 'good string']
    subject.process!(data)
    expect(data[2]).to eq clean_text
  end

  it 'should not blow up on symbols' do
    data = {key: :value}
    subject.process!(data)
    expect(data[:key]).to eq :value
  end
  
  it 'can deal with unicode hidden in ASCII-8BIT' do
    data = ["\xE2\x9C\x89 Hello".force_encoding(Encoding::ASCII_8BIT)]
    subject.process!(data)
    expect { JSON.generate(data) }.to_not raise_error
  end

  it 'can deal with unicode hidden in ASCII-8BIT when the string is frozen' do
    data = ["\xE2\x9C\x89 Hello".force_encoding(Encoding::ASCII_8BIT).freeze]
    subject.process!(data)
    expect { JSON.generate(data) }.to_not raise_error
  end
end
