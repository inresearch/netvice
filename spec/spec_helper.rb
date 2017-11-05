require "bundler/setup"
require "netvice"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Netvice.configure do
      logger nil
    end
  end
end

def json_fixture(file)
  filepath = "./spec/fixtures/#{file}.json"
  content = File.read(filepath)
  JSON.parse(content)
end

def stub_json(path, fixture_path, method: :get)
  method = [method] unless method.is_a?(Array)
  method.each do |m|
    stub_request(m, path)
      .to_return(status: 200, body: json_fixture(fixture_path).to_json)
  end
end
