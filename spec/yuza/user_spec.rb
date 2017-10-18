require "spec_helper"

describe Yuza::User do
  subject { described_class }

  describe '#init' do
    it 'accepts setting with hash' do
      user = subject.new(name: "Adam")
      expect(user.name).to eq "Adam"
      expect(user.id).to be_nil
    end

    it 'raises error when argument not a Hash' do
      expect { subject.new([]) }.to raise_error(ArgumentError)
    end
  end # init

  describe '#where_id' do
    it 'returns user when found' do
      stub_json("http://localhost:2000/users/5", "user/where_id_success")

      user = subject.where_id("5")
      expect(user.id).to eq "5"
      expect(user.name).to eq "Adam"
      expect(user.email).to eq "adam@wego.com"
      expect(user.created_at).to be_a Time
      expect(user.updated_at).to be_a Time
    end

    it 'returns nil when not found' do
      stub_json("http://localhost:2000/users/5", "user/where_id_missing")
      user = subject.where_id("5")
      expect(user).to be_nil
    end
  end # where_id

  describe '#save!' do
    before do
      stub_json("http://localhost:2000/users/5", "user/where_id_success")
      stub_request(:patch, "http://localhost:2000/users/5").
        to_return(status: 200, body: {success: true}.to_json)
    end

    it 'updates and reload the data' do
      user = subject.where_id("5")
      user.name = "Aloha"
      user.save!
      expect(a_request(:patch, "http://localhost:2000/users/5")).to have_been_made.once
      expect(a_request(:get, "http://localhost:2000/users/5")).to have_been_made.times(2)
    end
  end # save

  describe '#attempt_login' do
    let(:user) { subject.where_id("5") }
    let(:sess) { user.attempt_login("Password01") }
    before do
      stub_json("http://localhost:2000/users/5", "user/where_id_success")
    end

    it 'returns false when credentials invalid' do
      stub_json("http://localhost:2000/sessions", "session/attempt_login_failed", method: :post)
      expect(sess).to eq false
    end

    it 'returns a session on valid credential' do
      stub_json("http://localhost:2000/sessions", "session/attempt_login_succeed", method: :post)
      expect(sess).to be_a Yuza::Session
    end
  end # attempt_login
end # Yuza::User
