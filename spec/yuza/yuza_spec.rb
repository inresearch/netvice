require 'spec_helper'

describe Netvice::Yuza do
  subject { described_class }

  before do
    Netvice.configure do
      app 'pageok'
      yuza do
        secret 'mysecret'
      end
    end
  end

  describe '#http' do
    it 'has user agent' do
      stub_json(/localhost:2000/, "dummy/response", method: [:get])
      Netvice::Yuza.http.get('/')
      expect(a_request(:get, /localhost:2000/).with(headers: {'User-Agent'=>/pageok/})).to have_been_made.once
    end

    it 'appends secret on post' do
      stub_json(/localhost/, "dummy/response", method: [:post, :patch])
      Netvice::Yuza.http.post('/', '{}')
      expect(a_request(:post, 'http://localhost:2000').with(body: {host: {secret: 'mysecret'}}.to_json)).to have_been_made.once
    end

    it 'appends secret to the path on get, delete and patch' do
      stub_json(/localhost/, "dummy/response", method: [:get])
      Netvice::Yuza.http.get('/')
      expect(a_request(:get, 'http://localhost:2000?secret=mysecret')).to have_been_made.once
    end
  end
end
