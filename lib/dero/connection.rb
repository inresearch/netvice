module Netvice::Dero::Connection
  @@http_conn = nil

  # represents the HTTP connection
  def http
    return @@http_conn if @@http_conn
    @@http_conn = setup_http_connection
  end

  private

  def setup_http_connection
    conf = Netvice.configuration.dero

    http_conn = Netvice::Connection.new(
      conf.base_url,
      timeout: conf.timeout,
      headers: {
        'User-Agent' => conf.user_agent
      })

    http_conn
  end
end
