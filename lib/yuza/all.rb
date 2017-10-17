require_relative "configuration"
require_relative "endpoints"
require_relative "response"
require_relative "user"

module Yuza
  extend self

  @@http_conn = nil

  # represents HTTP connection
  def http
    return @@http_conn if @@http_conn
    conf = Netvice.configuration.yuza
    @http_conn = Netvice::Connection.new(conf.base_url, timeout: conf.timeout)
  end
end
