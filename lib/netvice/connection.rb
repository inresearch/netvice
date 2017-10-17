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
      resp = session.get(path)
      resp = Response.new(resp.body, resp.status)
      resp.body = parse_json(resp.body) if json
      resp
    end

    def patch(path, body, json: true)
      resp = session.patch(path, body)
      resp = Response.new(resp.body, resp.status)
      resp.body = parse_json(resp.body) if json
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
