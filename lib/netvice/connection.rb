module Netvice
  class Connection
    Response = Struct.new(:body, :status)

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json'
    }

    attr_reader :base_url
    attr_reader :headers
    attr_reader :timeout

    def initialize(base_url, options={})
      @base_url = base_url
      @headers = DEFAULT_HEADERS.merge(options.fetch(:headers, {}))
      @timeout = options.fetch(:timeout)
    end

    def session
      return @session if @session
      @session = Patron::Session.new do |patron|
        patron.timeout = timeout
        patron.base_url = base_url
        patron.headers = headers
      end
      @session
    end

    def get(path, json: true)
      send_request(:get, path, json: json)
    end

    def patch(path, body, json: true)
      send_request(:patch, path, body: body, json: json)
    end

    def post(path, body, json: true)
      send_request(:post, path, body: body, json: json)
    end
    
    def send_request(method, path, body:nil, json:true)
      ob_body = Netvice::Sanitizer.obfuscate_sensitive_data(body)
      Netvice.logger.info(Rainbow("Sending ##{method.to_s.upcase}: #{path} <#{ob_body}>").cyan)
      resp = case method
             when :get then session.get(path)
             when :post then session.post(path, body.to_json)
             else
               session.send(method, path, body)
             end
      resp = Response.new(resp.body, resp.status)
      resp.body = parse_json(resp.body) if json
      Netvice.logger.info(Rainbow("Response #{resp.status}: #{Netvice::Sanitizer.obfuscate_sensitive_data(resp.body)}").magenta)
      resp
    end

    def inspect
      "#<Netvice::Connection base_url=#{base_url} timeout=#{timeout}>"
    end

    private

    def parse_json(body)
      body = JSON.parse(body)
      if body["success"]
        unless [TrueClass, FalseClass].include?(body["success"].class)
          body["success"] = false
        end
      end
      body
    end
  end # Connection
end # Netvice
