module Netvice
  class Connection
    include Netvice::Inspector
    Response = Struct.new(:body, :status)

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json'
    }

    attr_reader :base_url
    attr_reader :header
    attr_reader :timeout
    attr_reader :pipelines

    def initialize(base_url, options={})
      @base_url = base_url
      @header = options[:header] || options[:headers] || {}
      @header = DEFAULT_HEADERS.merge(@header)
      @timeout = options.fetch(:timeout)
      @pipelines = []
    end

    # creating new pipeline, the opts basically the states that will
    # instantiate new connection pipeline object
    def add_pipeline(name, opts={})
      pl = Netvice::ConnectionPipeline.new(opts.merge(name: name))
      @pipelines << pl
      pl
    end

    def session
      return @session if @session
      @session = Patron::Session.new do |patron|
        patron.timeout = timeout
        patron.base_url = base_url
        patron.headers = header
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

    def delete(path, json: true)
      send_request(:delete, path, json: json)
    end
    
    def send_request(method, path, body:nil, json:true)
      path, body = perform_pipeline_manipulation(method, path, body)
      ob_body = Netvice::Sanitizer.obfuscate_sensitive_data(body)
      Netvice.logger.info(Rainbow("Sending ##{method.to_s.upcase}: #{path} <#{ob_body}>").cyan)

      resp = case method
             when :get then session.get(path)
             when :delete then session.delete(path)
             else
               session.send(method, path, body.to_json)
             end

      resp = Response.new(resp.body, resp.status)
      resp.body = parse_json(resp.body) if json
      Netvice.logger.info(Rainbow("Response #{resp.status}: #{Netvice::Sanitizer.obfuscate_sensitive_data(resp.body)}").magenta)
      resp
    rescue Patron::TimeoutError => e
      new_err = Netvice::TimeoutError.new(e.message)
      new_err.set_backtrace(e.backtrace)
      raise new_err
    rescue => e
      new_err = Netvice::RuntimeError.new(e.message)
      new_err.set_backtrace(e.backtrace)
      raise new_err
    end

    def inspect
      inspector([:base_url, :timeout, :pipelines])
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

    def perform_pipeline_manipulation(method, path, body)
      path = path.dup if path
      body = body.dup if body
      pipelines.each do |pipeline|
        next unless pipeline.for_method?(method)
        Netvice.logger.info(Rainbow("Execute pipeline: #{pipeline.name}").yellow)
        path, body = pipeline.call(path, body)
      end
      [path, body]
    end
  end # Connection
end # Netvice
