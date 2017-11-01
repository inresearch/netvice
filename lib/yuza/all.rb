module Netvice
  module Yuza
    autoload :Configuration, "yuza/configuration"
    autoload :Response, "yuza/response"
    autoload :User, "yuza/user" 
    autoload :Session, "yuza/session"
    extend self

    RuntimeError = Class.new(Netvice::RuntimeError)
    @@http_conn = nil

    # represents HTTP connection
    def http
      return @@http_conn if @@http_conn
      conf = Netvice.configuration.yuza
      @http_conn = Netvice::Connection.new(
        conf.base_url, timeout: conf.timeout)
    end
  end
end
