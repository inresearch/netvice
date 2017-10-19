require "spec_helper"

describe Netvice::Connection do
  subject do
    described_class.new(
      "http://example.com",
      header: {'User-Agent' => 'rspec'},
      timeout: 10
    )
  end

  before do
    %i[get post patch delete].each do |method|
      stub_json("http://example.com/do", "dummy/response", method: method)
    end
  end

  context 'on success' do
    it 'always returns Netvice::Connection::Response' do
      expect(subject.get("/do")).to be_a Netvice::Connection::Response
      expect(subject.post("/do", {})).to be_a Netvice::Connection::Response
      expect(subject.delete("/do")).to be_a Netvice::Connection::Response
      expect(subject.patch("/do", {})).to be_a Netvice::Connection::Response
    end

    it 'parses the response' do
      resp = subject.get("/do")
      expect(resp.status).to eq 200
      expect(resp.body).to eq({"success"=>true, "errors"=>{}, "data"=>{"dummy"=>true}})
    end

    it 'respect the header' do
      subject.get("/do")
      expect(a_request(:get, "example.com/do").with(headers: {'User-Agent'=>'rspec'}))
        .to have_been_made.once
    end
  end # on success

  context 'on error' do
    context 'general' do
      before do
        allow(subject).to receive(:send_request).and_raise(Netvice::NetworkError)
      end
      it 'raises Netvice::NetworkError' do
        expect { subject.get("/do") }.to raise_error(Netvice::NetworkError)
        expect { subject.delete("/do") }.to raise_error(Netvice::NetworkError)
        expect { subject.post("/do", {}) }.to raise_error(Netvice::NetworkError)
        expect { subject.patch("/do", {}) }.to raise_error(Netvice::NetworkError)
      end
    end # general
  end # on error
end # Netvice::Connection
