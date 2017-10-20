require "logger"
require "patron"
require "json"
require "date"
require "rainbow"

require "netvice/version"

module Netvice
  autoload :Settable, "netvice/settable"
  autoload :Initable, "netvice/initable"
  autoload :Inspector, "netvice/inspector"
  autoload :Timestampable, "netvice/timestampable"
  autoload :Configurable, "netvice/configurable"
  autoload :Reloadable, "netvice/reloadable"
  autoload :Configuration, "netvice/configuration"
  autoload :Connection, "netvice/connection"
  autoload :Model, "netvice/model"
  autoload :Sanitizer, "netvice/sanitizer"
  autoload :FakeLogger, "netvice/fake_logger"
  autoload :Dimensionable, "netvice/dimensionable"

  module Dimensions
    autoload :Array, "netvice/dimensions/array"
    autoload :Boolean, "netvice/dimensions/boolean"
    autoload :Fixnum, "netvice/dimensions/fixnum"
    autoload :Float, "netvice/dimensions/float"
    autoload :Hash, "netvice/dimensions/hash"
    autoload :String, "netvice/dimensions/string"
  end

  RuntimeError = Class.new(StandardError)
  NetworkError = Class.new(RuntimeError)
  TimeoutError = Class.new(NetworkError)
  WrongDimension = Class.new(RuntimeError)

  @@config = Netvice::Configuration.new
  @@fake_logger = FakeLogger.new

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

  def self.logger
    Netvice.configuration.logger || @@fake_logger
  end
end # Netvice

require "yuza/all"
