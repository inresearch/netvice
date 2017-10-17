require "patron"
require "json"
require "date"

require "netvice/version"
require "netvice/settable"
require "netvice/initable"
require "netvice/timestampable"
require "netvice/configurable"
require "netvice/configuration"
require "netvice/connection"

require "yuza/all"

module Netvice
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
