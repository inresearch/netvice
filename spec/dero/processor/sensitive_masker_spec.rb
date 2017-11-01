require "spec_helper"

describe Dero::Processor::SensitiveMasker do
  subject { described_class }
  after { Netvice.reset_configuration! }
  let(:data) {{
    'foo' => 'bar',
    'password' => 'hello',
    'the_secret' => 'hello',
    'a_password_here' => 'hello',
    'mypasswd' => 'hello',
    'test' => 1,
    :ssn => '123-45-6789', # test symbol handling
    'social_security_number' => 123456789,
    'user_field' => 'user',
    'user_field_foo' => 'hello',
    'query_string' => 'foo=bar%E9' # test utf8 handling
  }}

  it 'should filter http data' do
    Netvice.conf.dero.masked_fields ['user_field']
    payload = {'sentry.interfaces.Http' => {'data' => data}}

    subject.process!(payload)
    expect(payload).to eq ({
      "sentry.interfaces.Http"=>
      {"data"=>
       {"foo"=>"bar",
        "password"=>"*********",
        "the_secret"=>"*********",
        "a_password_here"=>"*********",
        "mypasswd"=>"*********",
        "test"=>1,
        :ssn=>"*********",
        "social_security_number"=>0,
        "user_field"=>"*********",
        "user_field_foo"=>"hello",
        "query_string"=>"foo=bar"}}
    })
  end

  it 'should filter json data' do
    payload = {'json' => data}.to_json
    subject.process!(payload)
    payload = JSON.parse(payload)
    expect(payload).to eq({
    "json"=>
      {"foo"=>"bar",
         "password"=>"*********",
         "the_secret"=>"*********",
         "a_password_here"=>"*********",
         "mypasswd"=>"*********",
         "test"=>1,
         "ssn"=>"*********",
         "social_security_number"=>0,
         "user_field"=>"user",
         "user_field_foo"=>"hello",
         "query_string"=>"foo=bar"}
    })
  end

  it 'should filter json embedded in a ruby object' do
    payload = {
      'data' => {
        'json' => %w(foo bar).to_json,
        'json_hash' => {'foo' => 'bar'}.to_json,
        'sensitive' => {'password' => 'secret'}.to_json
      }
    }

    subject.process!(payload)
    expect(payload).to eq({"data"=>
      {"json"=>"[\"foo\",\"bar\"]",
         "json_hash"=>"{\"foo\":\"bar\"}",
         "sensitive"=>"{\"password\":\"*********\"}"}
    })
  end

  it 'should not fail when given json is invalid' do
    payload = {
      'data' => {
        'invalid' => "{\r\n\"key\":\"value\",\r\n \"foo\":{\"bar\":\"baz\"}\r\n"
      }
    }
    subject.process!(payload)
    expect { JSON.parse(payload['data']['invalid']) }.to raise_error(JSON::ParserError)
  end

  it 'should filter credit card values' do
    payload = {
      'ccnumba' => '4242424242424242',
      'ccnumba_int' => 4242424242424242
    }

    subject.process!(payload)
    expect(payload).to eq({
      'ccnumba' => '*********',
      'ccnumba_int' => 0
    })
  end

  it 'sanitizes hashes nested in arrays' do
    payload = {
      'empty_array' => [],
      'array' => [{'password' => 'secret'}]
    }

    subject.process!(payload)
    expect(payload).to eq({"empty_array"=>[], "array"=>[{"password"=>"*********"}]})
  end

  context 'query string' do
    it 'sanitizes' do
      payload = {
        'dero.interface.Http' => {
          'data' => {
            'query_string' => 'foo=bar&password=secret'
          }
        }
      }

      subject.process!(payload)
      expect(payload).to eq({"dero.interface.Http"=>{"data"=>{"query_string"=>"foo=bar&password=*********"}}})
    end

    it 'handles when given in symbol' do
      payload = {
        'dero.interface.Http' => {
          'data' => {
            :query_string => 'foo=bar&password=secret'
          }
        }
      }

      subject.process!(payload)
      expect(payload).to eq({"dero.interface.Http"=>{"data"=>{:query_string=>"foo=bar&password=*********"}}})
    end

    it 'handles multiple values for a key' do
      payload = {
        'dero.interface.Http' => {
          'data' => {
            'query_string' => 'foo=bar&foo=fubar&foo=barfoo'
          }
        }
      }

      subject.process!(payload)
      expect(payload).to eq({"dero.interface.Http"=>{"data"=>{"query_string"=>"foo=bar&foo=fubar&foo=barfoo"}}})
    end

    it 'handles url encoded keys and values' do
      encoded_query_string = 'Bio+4%24=cA%24%7C-%7C+M%28%29n3%5E'
      payload = {
        'sentry.interface.Http' => {
          'data' => {
            'query_string' => encoded_query_string
          }
        }
      }

      subject.process!(payload)
      expect(payload).to eq({"sentry.interface.Http"=>{"data"=>{"query_string"=>"Bio+4%24=cA%24%7C-%7C+M%28%29n3%5E"}}})
    end

    # Sometimes this sort of thing can show up in request headers,
    # e.g. X-REQUEST-START on Heroku
    it 'does not censor milliseconds since the epoch' do
      payload = {
        millis_since_epoch: 1507671610403.to_s
      }

      subject.process!(payload)
      expect(payload).to eq(:millis_since_epoch=>"1507671610403")
    end
  end # query string
end
