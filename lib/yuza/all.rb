module Netvice
  module Yuza
    autoload :Configuration, "yuza/configuration"
    autoload :Response, "yuza/response"
    autoload :User, "yuza/user" 
    autoload :Session, "yuza/session"
    autoload :Paths, "yuza/paths"
    autoload :Connection, "yuza/connection"

    RuntimeError = Class.new(Netvice::RuntimeError)

    extend Netvice::Yuza::Connection
  end
end
