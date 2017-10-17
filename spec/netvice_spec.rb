require "spec_helper"

RSpec.describe Netvice do
  it "has a version number" do
    expect(Netvice::VERSION).not_to be nil
  end
end

def json_fixture(file)
  filepath = "./spec/fixtures/#{file}.json"
  content = File.read(filepath)
  JSON.parse(content)
end

def stub_json(path, fixture_path, method: :get)
  stub_request(method, path)
    .to_return(status: 200, body: json_fixture(fixture_path).to_json)
end
