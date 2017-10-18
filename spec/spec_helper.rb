require "bundler/setup"
require "netvice"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
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
