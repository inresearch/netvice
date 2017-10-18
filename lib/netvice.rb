require "patron"
require "json"
require "date"

require "netvice/version"
require "yuza/all"

module Netvice
  autoload :Settable, "netvice/settable"
  autoload :Initable, "netvice/initable"
  autoload :Timestampable, "netvice/timestampable"
  autoload :Configurable, "netvice/configurable"
  autoload :Configuration, "netvice/configuration"
  autoload :Connection, "netvice/connection"

  RuntimeError = Class.new(StandardError)
  @@config = Netvice::Configuration.new

  # for getting the configuration object
  def self.configuration
    @@config
  end

  # for configuration block
  def self.configure(&block)
    @@config.instance_eval(&block)
    @@config
  end # configure
end # Netvice
