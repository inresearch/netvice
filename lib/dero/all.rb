module Dero
  autoload :Configuration, "dero/configuration"

  module Kernel
    autoload :Line, "dero/kernel/line"
    autoload :Backtrace, "dero/kernel/backtrace"
  end

  RuntimeError = Class.new(Netvice::RuntimeError)
  @@http_conn = nil

  def http
    return @@http_conn if @@http_conn
    conf = Netvice.configuration.dero
    @http_conn = Netvice::Connection.new(
      conf.base_url, timeout: conf.timeout)
  end
end
