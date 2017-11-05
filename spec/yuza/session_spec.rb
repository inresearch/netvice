require "spec_helper"

describe Netvice::Yuza::Session do
  subject { described_class }

  describe "#where_id" do
    it "returns session when found" do
      stub_json(%r{localhost:2000/sessions/1}, "session/attempt_login_succeed")
      sess = subject.where_code("1")
      expect(sess.code).to eq "1"
      expect(sess.id).to eq "f904ff9f-26fe-4054-86a6-cbae5cd066af"
    end
  end # where_id
end # Netvice::Yuza::Session
