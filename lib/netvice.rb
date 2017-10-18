require "patron"
require "json"
require "date"

require "netvice/version"
require "yuza/all"

module Netvice
  autoload :Settable, "netvice/settable"
  autoload :Initable, "netvice/initable"
  autoload :Inspector, "netvice/inspector"
  autoload :Timestampable, "netvice/timestampable"
  autoload :Configurable, "netvice/configurable"
  autoload :Configuration, "netvice/configuration"
  autoload :Connection, "netvice/connection"
  autoload :Model, "netvice/model"

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

  def self.reset_configuration!
    @@config = Netvice::Configuration.new
  end
end # Netvice
