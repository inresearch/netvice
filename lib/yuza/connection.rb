module Netvice::Yuza::Connection
  # represents HTTP connection
  def http
    return @http_conn if @http_conn
    @http_conn = setup_http_connection
  end

  private

  def setup_http_connection
    conf = Netvice.configuration.yuza
    http_conn = Netvice::Connection.new(conf.base_url, timeout: conf.timeout)

    http_conn.add_pipeline(:secret_for_get_and_delete, path_proc: -> (path) {
      query = URI.parse(path).query
      query_hash = CGI.parse(query)
      query_hash['secret'] = conf.secret
      host = path.split('?').first
      query = URI.encode_www_form(query_hash)
      "#{host}?#{query}"
    }, for: [:get, :delete])

    http_conn.add_pipeline(:secret_for_json_body, body_proc: -> (body) {
      body['host'] = {'secret' => conf.secret}
      body
    }, for: [:patch, :post])

    http_conn
  end
end
